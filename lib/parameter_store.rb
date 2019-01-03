require 'aws-sdk-ssm'
module ParameterStore
  
  class << self
    attr_accessor :configuration
    attr_reader :aws_config

    @@aws_config ||= Aws::SSM::Client.new
  end

  def self.configure(environment, application_name)
    self.configuration ||= Configuration.new(environment, application_name)
    #yield(configuration)
  end

  def self.get_parameter(name)
    if name.is_a? String
      params[name.to_sym]
    else
      params[name]
    end
  end
  
  def self.must_get_parameter(name)
    val = get_parameter(name)
    if val.nil?
      raise ParameterMissingError, "required parameter does not have a non-nil value"
    end
    val
  end

  class ParameterMissingError < StandardError ; end

  class Configuration
    attr_accessor :application_name
    attr_accessor :environment

    def initialize(environment, application_name)
      #@environment = ENV['RAILS_ENV']
      @environment = environment
      @application_name = application_name
    end
  end

  private

  def self.params
    @params ||= get_global.merge(get_app_specific)
  end

  def self.get_global
    values = @@aws_config.get_parameters_by_path(path: "/#{configuration.environment}/global/", with_decryption: true, max_results: 10)
    parse_values(values)
  end
  
  def self.get_app_specific
    values = @@aws_config.get_parameters_by_path(path: "/#{configuration.environment}/#{configuration.application_name}/", with_decryption: true, max_results: 10)
    parse_values(values)
  end

  def self.parse_values(values)
    configuration_values = {}
    loop do
      values.parameters.each do |parameter|
        configuration_values[parameter[:name].to_s.split('/').last.to_sym] = parameter[:value]
      end
      break if values.next_token.nil?
      values = values.next_page
    end
    configuration_values
  end

end
