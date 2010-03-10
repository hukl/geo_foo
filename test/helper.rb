require 'rubygems'
require 'test/unit'
require 'active_record'

config_file = File.join(File.dirname(__FILE__), '..', 'test_database.yml')
database_config = YAML.load_file config_file
database_config[:adapter] = 'postgresql'
ActiveRecord::Base.establish_connection database_config

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'geo_foo'

class Test::Unit::TestCase
end
