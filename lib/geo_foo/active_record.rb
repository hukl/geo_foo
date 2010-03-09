module GeoFoo
  module ActiveRecord
    def self.included(base)
      raise
      base.extend ClassMethods
    end
  end
  
  module ClassMethods
    def hello
      puts "ar"
    end
  end
end