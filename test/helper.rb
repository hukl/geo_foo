require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_support'
require 'active_support/test_case'

config_file = File.join(File.dirname(__FILE__), '..', 'test_database.yml')
ActiveRecord::Base.establish_connection( YAML.load_file config_file )

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'geo_foo'

class ActiveSupport::TestCase
  
  def execute sql
    ActiveRecord::Base.connection.execute sql
  end

  def query sql
    ActiveRecord::Base.connection.query sql
  end

  def query_scalar sql
    query(sql).first.first
  end
  
  def point_for lat, lon
    execute("SELECT #{GeoFoo.as_point(lat, lon)}")[0]["st_geomfromtext"]
  end
  
end
