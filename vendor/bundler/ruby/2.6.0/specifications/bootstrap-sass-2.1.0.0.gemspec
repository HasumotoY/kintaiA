# -*- encoding: utf-8 -*-
# stub: bootstrap-sass 2.1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap-sass".freeze
  s.version = "2.1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Thomas McDonald".freeze]
  s.date = "2012-09-06"
  s.email = "tom@conceptcoding.co.uk".freeze
  s.homepage = "http://github.com/thomas-mcdonald/bootstrap-sass".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Twitter's Bootstrap, converted to Sass and ready to drop into Rails or Compass".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<compass>.freeze, [">= 0"])
      s.add_development_dependency(%q<sass-rails>.freeze, ["~> 3.1"])
    else
      s.add_dependency(%q<compass>.freeze, [">= 0"])
      s.add_dependency(%q<sass-rails>.freeze, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<compass>.freeze, [">= 0"])
    s.add_dependency(%q<sass-rails>.freeze, ["~> 3.1"])
  end
end
