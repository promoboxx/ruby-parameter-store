module RubyParameterStore
  class Retrieve
    require 'singleton'

    include Singleton

    def self.get(name)
      params[name.to_sym]
    end

    def self.get!(name)
      val = get(name)
      if val.nil?
        raise ParameterMissingError, "required parameter does not have a non-nil value"
      end
      val
    end

    def self.clear
      @_params = nil
    end

    class RubyParameterStore::ParameterMissingError < StandardError ; end

    private

    def self.params
      @_params ||= get_global.merge(get_app_specific)
    end

    def self.get_global
      values = config.aws_client.get_parameters_by_path({
        path: "/#{config.environment}/global/",
        with_decryption: true,
        max_results: 10
      })
      parse_values(values)
    end

    def self.get_app_specific
      values = config.aws_client.get_parameters_by_path({
        path: "/#{config.environment}/#{config.app_name}/",
        with_decryption: true,
        max_results: 10
      })
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

    def self.config
      RubyParameterStore.configuration
    end

  end
end

