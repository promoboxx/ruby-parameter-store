Gem::Specification.new do |s|
  s.name = "ruby-parameter-store"
  s.version = "0.0.1"
  s.date = "2018-12-14"
  s.author = 'Promoboxx Inc'
  s.summary = "Ruby Parameter Store implements Promoboxx parameter retrieval and coalescence in Ruby"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_dependency 'aws-sdk-ssm'

  s.require_paths = ["lib"]
  s.files = ['lib/ruby_parameter_store.rb']
  s.test_files = ['spec/ruby_parameter_store_spec.rb']
end
