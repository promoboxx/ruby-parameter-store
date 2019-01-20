Gem::Specification.new do |s|
  s.name = "ruby-parameter-store"
  s.version = "0.0.1"
  s.date = "2018-12-14"
  s.author = 'Promoboxx Inc'
  s.summary = "Ruby Parameter Store implements Promoboxx parameter retrieval and coalescence in Ruby"
  s.required_ruby_version = '>= 2.3.1'

  s.add_dependency 'aws-sdk-ssm'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency "simplecov"
end
