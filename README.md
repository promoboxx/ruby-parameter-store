# ruby-parameter-store

[![CircleCI](https://circleci.com/gh/promoboxx/ruby-parameter-store.svg?style=svg)](https://circleci.com/gh/promoboxx/ruby-parameter-store)
[![Maintainability](https://api.codeclimate.com/v1/badges/dbae4922f2e021549af9/maintainability)](https://codeclimate.com/repos/5c1ac8712cae6002b40016f8/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/dbae4922f2e021549af9/test_coverage)](https://codeclimate.com/repos/5c1ac8712cae6002b40016f8/test_coverage)

## Development and Building

1. Update code
2. Increment version in gemspec
3. Increment version in Gemfury publish command in .circleci/config.yml
4. Open pull request
5. Merge pull request
6. Circleci master build will publish to Gemfury

## Usage

Gemfile:

```ruby
source 'https://gem.fury.io/promoboxx/' do
  gem 'ruby-parameter-store'
end
```

or

```ruby
gem 'ruby-jwt-auth', git: 'https://github.com/Promoboxx/ruby-parameter-store.git'
```

### Configure the RubyParameterStore singleton in config/initializers/ruby_parameter_store.rb
```
RubyParameterStore.configure do |config|
  config.environment = "local"
  config.app_name = "foobar"
  config.aws_client = Aws::SSM::Client.new
end
```
### Retrieving values

#### Get with silent fail

* Returns nil if the value was not set.

```
RubyParameterStore::Retrieve.get('param_name')
```

#### Get with loud fail

* Throws `RubyParameterStore::ParameterMissingError` if value returned would be nil

```
RubyParameterStore::Retrieve.get!('param_name')
```

## Testing

### Mocks

```
rspec
```

### Actual

```
export AWS_REGION="us-east-1"
aws-vault exec pbxx-dev -- rspec spec
```

## Running in Docker

Add the following to your docker-compose.yml's environment section for the app that will be using ruby-parameter-store

```
AWS_REGION: us-east-1
AWS_SECURITY_TOKEN: $AWS_SECURITY_TOKEN
AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
AWS_DEFAULT_REGION: us-east-1
AWS_SESSION_TOKEN: $AWS_SESSION_TOKEN
AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
```

To run the container, just add ```aws-vault exec pbxx-dev --``` before your command

So, for instance, to run rails console on API once you have added RubyParameterStore package to it:

```
aws-vault exec pbxx-dev --  docker-compose run api bundle exec rails c
```

## Viewing Values in Amazon

* aws-vault login pbxx-dev to log in
* go to services -> Systems Manager
* left hand nav bar at the bottom under shared resources -> RubyParameter Store

You can then page through

## Naming Convention

* Our convention for naming parameters is `/environment/application/key`, so for instance `/development/accounting/db_user`
* We can also set global values for an environment like, for instance `/development/global/api_endpoint`
* Application values will override global values, so `/test/global/test` as a key with a value of global_test would be overridden in a test application if we had another parameter configured as `/test/test/test`

## Adding new parameters

RubyParameters should be added as SecureStrings so that the values are encrypted. They will automatically be decrypted by the RubyParameterStore when they are pulled down.

I have been using the alias/aws/ssm key to encrypt my values. You can still see the values in RubyParameterStore if you need to from the web UI.
