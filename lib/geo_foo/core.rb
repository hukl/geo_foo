module GeoFoo
  
  module Core
    SRID = 4326 # WGS-84
    EarthRadius = 6370986.0 # meters (as used by postgis' ST_Distance_Sphere())
    TableName = "locations"
  
    # execute an SQL query on the database 
    def self.execute query
      ActiveRecord::Base.connection.execute( query ).to_a
    end
  
    # return a postgis string representation of the given coordinates
    def self.as_point lat, lon
      # Intentionally use (lat,lon) and not (lon,lat), because latitude is the
      # 'horizontal' coordinate.
      # See: http://archives.postgresql.org/pgsql-general/2008-02/msg01393.php
      "ST_GeomFromText('POINT(#{lon} #{lat})', #{SRID})"
    end
  
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
  
    # return latitude, longitude for a given id
    def self.find_coords_by_id id
      r = (execute "SELECT ST_Y(point), ST_X(point) FROM #{TableName} "\
                   "WHERE id = #{id}")[0]
      # Intentionally return (y,x) which corresponds to (lat,lon). See as_point().
      [r["st_y"].to_f, r["st_x"].to_f]
    end
  
    # store a point in the location table. returns the points id.
    def self.store_location lat, lon
      (execute "INSERT INTO #{TableName} (point) VALUES (#{as_point(lat,lon)})"\
               "RETURNING id").first["id"].to_i
    end
  
    # delete a location from the database
    def self.delete_location id
      execute "DELETE FROM #{TableName} WHERE id = #{id}"
    end
  
    # returns the number of locations currently in the database
    def self.location_count
      (execute "SELECT count(*) FROM #{TableName}").first["count"].to_i
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