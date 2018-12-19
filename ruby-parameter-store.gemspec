Gem::Specification.new do |s|
  s.name = %q{ruby-parameter-store}
  s.version = "0.0.0"
  s.date = %q{2018-12-14}
  s.author = 'Promoboxx Inc'
  s.summary = %q{Ruby Parameter Store implements Promoboxx parameter retrieval and coalescence in ruby}

  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'rspec', '~> 3.1'

  s.require_paths = ["lib"]
  s.files = ['lib/parameter_store.rb']
  s.test_files = ['spec/parameter_store_spec.rb']
end
