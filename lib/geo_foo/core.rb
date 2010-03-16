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
  
end