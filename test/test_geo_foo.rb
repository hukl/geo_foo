require 'helper'

class TestGeoFoo < MiniTest::Unit::TestCase
  def execute sql
    ActiveRecord::Base.connection.execute sql
  end

  def query sql
    ActiveRecord::Base.connection.query sql
  end

  def query_scalar sql
    query(sql)[0][0]
  end

  def test_database_connection
    # perform a query first to 'wake-up' the connection
    assert_equal(query_scalar("SELECT 23").to_i, 23)
    assert ActiveRecord::Base.connected?, "database connection esteblished"
  end

  def test_postgis_database
    assert_equal(query_scalar('select count(*) from geometry_columns').to_i, 0)
  end
end
