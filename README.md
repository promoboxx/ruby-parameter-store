# Ruby RubyParameter Store
Ruby RubyParameter Store package

## Usage

### Configure the RubyParameterStore singleton in config/initializers/ruby_parameter_store.rb
```
RubyParameterStore.configure do |config|
  config.environment = "local"
  config.app_name = "foobar",
  config.aws_client = Aws::SSM::Client.new
end
```
### Retrieve values

```
RubyParameterStore::Retrieve.get_parameter('TEST_PARAM')
```

`get_parameter` runs against a memoized lookup for the params, meaning getting anything will cache the values we have in AWS. Keys will work with symobls or strings.  Returns nil if the value was not set.

### Must get a value

```RubyParameterStore::Retriever.must_get_parameter(:db_pass) ``` # Throws RubyParameterStore::ParameterMissingError if value returned would be nil

## Testing

### Mocks

`rspec`

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
```aws-vault exec pbxx-dev --  docker-compose run api bundle exec rails c```

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

RubyParameters should be added as SecureStrings so that the values are encrypted. They will automatically be decrypted by the RubyParameter Store when they are pulled down.

I have been using the alias/aws/ssm key to encrypt my values. You can still see the values in RubyParameter Store if you need to from the web UI.
