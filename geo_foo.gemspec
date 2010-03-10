# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{geo_foo}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["agnat", "hukl"]
  s.date = %q{2010-03-10}
  s.description = %q{Geo makes it easy to interact with Postgis without hacking AR}
  s.email = %q{contact@smyck.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "geo_foo.gemspec",
     "lib/geo_foo.rb",
     "lib/geo_foo/active_record.rb",
     "lib/geo_foo/core.rb",
     "lib/geo_foo/migration.rb",
     "lib/geo_foo/numeric.rb",
     "lib/geo_foo/scope.rb",
     "test/helper.rb",
     "test/test_geo_foo.rb"
  ]
  s.homepage = %q{http://github.com/hukl/geo_foo}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{An extensible Postgis library}
  s.test_files = [
    "test/helper.rb",
     "test/test_geo_foo.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, [">= 0"])
    else
      s.add_dependency(%q<minitest>, [">= 0"])
    end
  else
    s.add_dependency(%q<minitest>, [">= 0"])
  end
end

