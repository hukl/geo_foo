module GeoFoo
  module ActiveRecord
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
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
    
    # return latitude, longitude for a given id
    def find_coords_by_id id
      result = connection.execute(
        "SELECT ST_Y(point), ST_X(point) FROM #{table_name} WHERE id = #{id}")[0]
      # Intentionally return (y,x) which corresponds to (lat,lon). See as_point().
      [result["st_y"].to_f, result["st_x"].to_f]
    end
    
    # XXX handle case where lat is (close to) +-90deg (poles)
    def bbox_size latitude, radius
      (radius.to_f / (GeoFoo::EarthRadius * Math.cos(latitude.to_rad))).to_deg
    end
  end
  
  module InstanceMethods
    
    def point_to_coords
      base = self.class
      
      result = base.connection.execute(
        "SELECT ST_Y(point), ST_X(point) FROM #{base.table_name} " \
        "WHERE id = #{self.id}"
      )[0]
      
      { :latitude => result["st_y"].to_f, :longitude => result["st_x"].to_f }
    end
  end
end

