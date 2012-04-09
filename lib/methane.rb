require 'slop'

require 'methane/version'
require 'methane/config'
require 'methane/proxy'
require 'methane/notifications'
require 'methane/app'

module Methane
  
  class << self
    attr_accessor :config, :root, :debug
  end

  # Methane runner
  #
  # Reads options and bootstraps the app
  def self.run
    @root= Dir.pwd
    options = Slop.parse(:help => true, :multiple_switches => false) do
      banner "methane [options]"
      on :c, :config=, 'Use a different config file than ~/.methane/config'
      on :d, :debug=, 'Enable debugging.'
      on :v, :version do
        puts "Methane Campfire Client v.#{Methane::VERSION}"
        exit
      end
    end

    @debug = options.debug?
    @config = Methane::Config.new options[:config]
    @pids = []

    # Start libnotify/growl
    @pids << Process.fork do
      Methane::Proxy.start do |room, message|
        title = "#{message.user.name} in #{room.name}"
        body = message.body
        Methane::Notification.show(title, body)
      end
      detach
    end

    # Start Qt app
    Methane::App.start

    # End spawned processes
    @pids.map{ |pid| Process.kill(:KILL, pid) if pid }
    
  end # run

end #module
