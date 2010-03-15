module GeoFoo
  module ActiveRecord
    def self.included(base)
      base.extend ClassMethods
    end
  end
  
  module ClassMethods
    def add_geo_foo
      self.class_eval do
        def self.within_radius lat, lon, radius
          scoped(
            :conditions => [
              "ST_DWithin(#{GeoFoo.as_point(lat,lon)}, "\
              "point, #{bbox_size(lat, radius)}) AND ST_Distance_Sphere(" \
              "point, #{GeoFoo.as_point(lat,lon)}) < #{radius}"
            ]
          )
        end
      end
    end
    
    # XXX handle case where lat is (close to) +-90deg (poles)
    def bbox_size latitude, radius
      (radius.to_f / (GeoFoo::EarthRadius * Math.cos(latitude.to_rad))).to_deg
    end
  end
end

