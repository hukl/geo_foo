require 'geo_foo/scope'
require 'geo_foo/active_record'
require 'geo_foo/numeric'

module GeoFoo

end

ActiveRecord::Base.class_eval do
  include GeoFoo::ActiveRecord
end