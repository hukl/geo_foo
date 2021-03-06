require 'helper'
require 'models/location'

class TestGeoFoo < ActiveSupport::TestCase
  
  def setup
    query = "CREATE TABLE locations ( id serial PRIMARY KEY );"\
            "SELECT AddGeometryColumn('locations', 'point', 4326, 'POINT', 2);"\
            "CREATE INDEX locations_point_index ON locations USING GIST (point);"
    
    ActiveRecord::Base.connection.execute(query)
  end
  
  def teardown
    query = [
      "DROP TABLE locations;",
      "DELETE FROM geometry_columns WHERE f_table_name = 'locations';"
    ].join
    ActiveRecord::Base.connection.execute(query)
  end
  
  test "as_point" do
    latitude  = 5
    longitude = 42
    point = GeoFoo.as_point latitude, longitude
    assert query( "SELECT #{point}" )
    assert_equal 42, query_scalar("SELECT ST_X(#{point})").to_i
    assert_equal 5,  query_scalar("SELECT ST_Y(#{point})").to_i
  end
  
  test "setup of Location model" do
    assert_not_nil Location
  end
    
  test "creating a location" do
    assert_not_nil Location.create :point => point_for( 53.0, 13.0 )
  end
  
  test "within_radius is defined" do
    assert defined?(Location.within_radius), '#within_radius is not defined'
  end
  
  test "as_point is defined" do
    assert defined?(GeoFoo.as_point), '#as_point is not defined'
  end
  
  test "find locations within radius" do
    Location.create :point => point_for( 53.0000001, 13.0000001 )
    Location.create :point => point_for( 53.0000002, 13.0000002 )
    
    assert_equal 2, Location.within_radius(53.0000001, 13.0000001, 100.0).size
  end
  
  test "find no locations within radius" do
    Location.create :point => point_for( 53.0000001, 13.0000001 )
    Location.create :point => point_for( 53.0000002, 13.0000002 )
    
    assert_equal 0, Location.within_radius(54.0, 14.0, 100.0).size
  end
  
  test "point to coords" do
    location = Location.create :point => point_for( 53.1, 13.1 )
    
    assert (53.09...53.11).include?( location.point_to_coords[:latitude] )
    assert (13.09...13.11).include?( location.point_to_coords[:longitude] )
  end
  
  test "find_coords_by_id" do
    Location.create :point => point_for( 53.1, 13.1 )
    assert (53.09...53.11).include?( Location.find_coords_by_id(Location.last.id)[0])
    assert (13.09...13.11).include?( Location.find_coords_by_id(Location.last.id)[1])
  end
  
end
