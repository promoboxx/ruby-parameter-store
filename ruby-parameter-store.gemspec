Gem::Specification.new do |s|
  s.name = "ruby-parameter-store"
  s.version = "0.0.2"
  s.date = "2018-12-14"
  s.author = 'Promoboxx Inc'
  s.summary = "Ruby Parameter Store implements Promoboxx parameter retrieval and coalescence in Ruby"
  s.homepage = "https://github.com/promoboxx/ruby-parameter-store"
  s.required_ruby_version = '>= 2.3.1'

  s.add_dependency 'aws-sdk-ssm', '~> 1'
  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.4'
  s.add_development_dependency "simplecov", '~> 0.16'

  s.files = [
    'lib/ruby_parameter_store.rb',
    'lib/ruby_parameter_store/configuration.rb',
    'lib/ruby_parameter_store/retrieve.rb',
  ]
end
