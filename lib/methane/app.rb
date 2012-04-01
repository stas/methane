require 'Qt4'
require 'qtwebkit'
require 'libnotify'

module Methane
  
  # Main GUI class
  class App
    attr_accessor :app, :view

    # Build a new Qt window with a WebKit frame
    def self.start
      url = File.join(Methane.root, 'static', 'index.html')
      title = "Methane v.#{Methane::VERSION}"
      Methane::App.notify('Welcome', title)
      @app = Qt::Application.new([]) do
        @view = Qt::WebView.new do
          self.load Qt::Url.new("file://#{url}")
          self.setWindowTitle(title)
          self.resize 800,600
          self.show
        end
        self.exec
      end
    end #start

    # A simple wrapper around libnotify
    def self.notify(title, body)
      Libnotify.show(
        :summary    => title,
        :body       => body,
        :timeout    => 1.5,
        :urgency    => :critical, # :low, :normal, :critical
        :icon_path  => :'emblem-default'
      )
    end #notify

  end

end #module
