require 'aws-sdk-ssm'
require "ruby_parameter_store/configuration"
require "ruby_parameter_store/retrieve"

module RubyParameterStore

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

