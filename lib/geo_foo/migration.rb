module GeoFoo
  module ActiveRecord
    module Migration
      # migration helper: create the database table
      def self.create_posgis_point_table table_name
        self.connection.execute "CREATE TABLE #{table_name} (id serial PRIMARY KEY)"
        self.connection.execute "SELECT AddGeometryColumn('#{table_name}', 'point', #{SRID}, 'POINT', 2)"
        self.connection.execute "CREATE INDEX #{table_name}_point_index ON #{table_name} USING GIST (point)"
      end

      # migration helper: drop the database table
      def self.drop_posgis_point_table table_name
        self.connection.execute "DROP TABLE #{table_name}"
      end
    end
  end
end