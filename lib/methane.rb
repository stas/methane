require 'slop'

require 'methane/version'

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
      on :a, :account=, 'Campfire account.'
      on :t, :token=, 'User token.'
      on :s, :ssl=, 'Use SSL?', :default => true
      on :c, :config=, 'Use ~/.methanerc, overwrites options from above.'
      on :d, :debug=, 'Enable debugging.'
      on :v, :version do
        puts "Methane Campfire Client v.#{Methane::VERSION}"
        exit
      end
    end

    if (!@options.account? or !@options.token?) and !@options.config?
      puts @options
    end
  end # run

end #module
