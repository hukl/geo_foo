require 'geo_foo/core'
require 'helper'

class TestGeoFoo < Test::Unit::TestCase
  def test_database_connection
    # perform a query first to 'wake-up' the connection
    assert_equal(query_scalar("SELECT 5").to_i, 5)
    assert ActiveRecord::Base.connected?, "database connection esteblished"
  end

  def test_postgis_database
    assert(query('SELECT count(*) FROM geometry_columns'))
  end

  def test_as_point
    latitude = 5
    longitude = 42
    point = GeoFoo::Core.as_point latitude, longitude
    assert(query("SELECT #{point}"))
    assert_equal(query_scalar("SELECT ST_X(#{point})").to_i, 42)
    assert_equal(query_scalar("SELECT ST_Y(#{point})").to_i, 5)
  end

  def execute sql
    ActiveRecord::Base.connection.execute sql
  end

  def query sql
    ActiveRecord::Base.connection.query sql
  end

  def query_scalar sql
    query(sql).first.first
  end
end
