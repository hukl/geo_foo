require 'geo_foo/core'
require 'helper'
require 'models/location'

class TestGeoFoo < ActiveSupport::TestCase
  
  def setup
    ActiveRecord::Base.connection.execute(
      "CREATE TABLE locations (
         id    serial PRIMARY KEY,
         point geometry
       );"
    );
  end
  
  def teardown
    ActiveRecord::Base.connection.execute(
      "DROP TABLE locations;"
    )
  end
  
  test "database connection" do
    # perform a query first to 'wake-up' the connection
    assert_equal(query_scalar("SELECT 5").to_i, 5)
    assert ActiveRecord::Base.connected?, "database connection esteblished"
  end

  test "postgis database is present" do
    assert(query('SELECT count(*) FROM geometry_columns'))
  end

  test "as_point" do
    latitude = 5
    longitude = 42
    point = GeoFoo.as_point latitude, longitude
    assert(query("SELECT #{point}"))
    assert_equal(query_scalar("SELECT ST_X(#{point})").to_i, 42)
    assert_equal(query_scalar("SELECT ST_Y(#{point})").to_i, 5)
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
    assert_equal 53.1, location.point_to_coords[:latitude]
    assert_equal 13.1, location.point_to_coords[:longitude]
  end
  
end
