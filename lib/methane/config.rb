require 'yaml'

module Methane

  # Handles Methane config file entries
  #
  # Now its just loads the config file.
  class Config
    attr_accessor :account, :token, :raw, :location, :messages

    # Constructor
    #
    # @param path, [String] path to the configuration file, default to nil
    # @returns [Object], of parsed settings
    def initialize(path=nil)
      path ||="#{ENV['HOME']}/.methane/config"
      @location = File.dirname(path)
      # Used for temporary messages queue
      @messages = []
      
      begin
        @raw = YAML::load_file(path)
        load_settings(@raw)
      rescue
        @messages << "Sorry, configuration file could not be loaded from: #{path}"
      end

    end #initialize

    # Parses config file entries
    #
    # @param raw_data, [Hash] resulted from reading YAML file
    def load_settings(raw_data)
      # TODO: Add support for multiple accounts
      key = raw_data.keys.first
      if key != nil and raw_data[key]['account'] and raw_data[key]['token']
        @account = raw_data[key]['account']
        @token = raw_data[key]['token']
        @messages << "Configuration file loaded from: #{@location}"
      else
        @messages << "Configuration file doesn't seem ok."
      end
    end

  end

end
