require 'slop'

require 'methane/version'
require 'methane/notifications'
require 'methane/app'

module Methane
  
  class << self
    attr_accessor :options, :root
  end

  # Methane runner
  #
  # Reads options and bootstraps the app
  def self.run
    @root= Dir.pwd
    @options = Slop.parse(:help => true, :multiple_switches => false) do
      banner "methane [options]"
      on :c, :config=, 'Use a different config file than ~/.methane/config'
      on :d, :debug=, 'Enable debugging.'
      on :v, :version do
        puts "Methane Campfire Client v.#{Methane::VERSION}"
        exit
      end
    end

    if !@options.config?
      puts @options
    else
      Methane::App.start
    end
  end # run

end #module
