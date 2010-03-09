require 'geo_foo/scope'
require 'geo_foo/active_record'

module GeoFoo

end

ActiveRecord::Base.class_eval do
  include GeoFoo::ActiveRecord
end