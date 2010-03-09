module GeoFoo
  module ActiveRecord
    def self.included(base)
      base.extend ClassMethods
    end
  end
  
  module ClassMethods
    def add_geo_foo
      puts "ar"
      self.named_scope :within_radius, lambda { |lat, lon, radius|
        {
          :conditions => [
            "ST_DWithin(#{GeoFoo::Core.as_point(lat,lon)}, point, #{bbox_size(lat, radius)})"\
            " AND ST_Distance_Sphere(point, #{GeoFoo::Core.as_point(lat,lon)}) < #{radius}"
          ]
        }
      }
    end
    
    # XXX handle case where lat is (close to) +-90deg (poles)
    def bbox_size latitude, radius
      (radius.to_f / (GeoFoo::Core::EarthRadius * Math.cos(latitude.to_rad))).to_deg
    end
  end
end