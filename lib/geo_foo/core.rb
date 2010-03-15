module GeoFoo
  
  SRID = 4326 # WGS-84
  EarthRadius = 6370986.0 # meters (as used by postgis' ST_Distance_Sphere())
  
  # return a postgis string representation of the given coordinates
  def self.as_point lat, lon
    # Intentionally use (lat,lon) and not (lon,lat), because latitude is the
    # 'horizontal' coordinate.
    # See: http://archives.postgresql.org/pgsql-general/2008-02/msg01393.php
    "ST_GeomFromText('POINT(#{lon} #{lat})', #{SRID})"
  end
  
  module Core
    
    # find all locations within a radius for a given location
    def self.find_neighbours_by_coords lat, lon, radius=100.0
      # compute an appropriate bounding box size for this latitude
      # XXX handle case where lat is (close to) +-90deg (poles)
      bbox_size= (radius.to_f / (EarthRadius * Math.cos(lat.to_rad))).to_deg
      distance = "ST_Distance_Sphere(point, #{as_point(lat,lon)})"
      (execute "SELECT (id) FROM #{TableName} "\
               "WHERE ST_DWithin(#{as_point(lat,lon)}, point, #{bbox_size}) "\
               "AND #{distance} < #{radius} "\
               "ORDER BY #{distance}").map { |row| row["id"].to_i }
    end
    
    # migration helper: create the database table
    def self.create_table
      execute "CREATE TABLE #{TableName} (id serial PRIMARY KEY)"
      execute "SELECT AddGeometryColumn('#{TableName}', 'point', #{SRID}, 'POINT', 2)"
      execute "CREATE INDEX #{TableName}_point_index ON #{TableName} USING GIST (point)"
    end
  
    # migration helper: drop the database table
    def self.drop_table
      execute "DROP TABLE #{TableName}"
    end
  end
  
end