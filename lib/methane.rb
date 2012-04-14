require 'slop'
require 'multi_json'

require 'methane/version'
require 'methane/config'
require 'methane/notifications'
require 'methane/proxy'
require 'methane/server'
require 'methane/app'

module Methane

  # Force tinder to use yajl
  MultiJson.engine = :yajl
  
  class << self
    attr_accessor :config, :root, :debug
  end

  # Methane runner
  #
  # Reads options and bootstraps the app
  def self.run
    options = Slop.parse(:help => true, :multiple_switches => false) do
      banner "methane [options]"
      on :c, :config=, 'Use a different config file than ~/.methane/config'
      on :d, :debug, 'Enable debugging.'
      on :v, :version do
        puts "Methane Campfire Client v.#{Methane::VERSION}"
        exit
      end
    end

    self.root= Dir.pwd
    self.debug = options.debug?
    self.config = Methane::Config.new(options[:config])
    @pids = []

    # Start the server
    @pids << Process.fork do
      Methane::Server.new
    end

    # Start Qt app
    Methane::App.start

    # End spawned processes
    @pids.map{ |pid| Process.kill(:KILL, pid) if pid }
    
  end # run

end #module
