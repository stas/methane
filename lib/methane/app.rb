require 'Qt4'
require 'qtwebkit'

begin
  require 'libnotify'
rescue LoadError
  # TODO: load growl?
end

module Methane
  
  # Main GUI class
  class App
    attr_accessor :app, :view

    # Build a new Qt window with a WebKit frame
    def self.start
      url = File.join(Methane.root, 'static', 'index.html')
      icon = File.join(Methane.root, 'static', 'img', 'methane.png')
      title = "Methane v.#{Methane::VERSION}"
      Methane::App.notify('Welcome', title)
      @app = Qt::Application.new([]) do
        @view = Qt::WebView.new do
          self.load Qt::Url.new("file://#{url}")
          setWindowIcon(Qt::Icon.new(icon))
          setWindowTitle(title)
          resize 600,800
          show
        end
        self.exec
      end
    end #start

    # A simple wrapper around libnotify
    def self.notify(title, body, timeout=1.5, icon=:'')
      begin
        Libnotify.show(
          :summary    => title,
          :body       => body,
          :timeout    => 1.5,
          :icon_path  => :'emblem-default'
        )
      rescue NameError
        # TODO: use a different engine
      end
      #end
    end #notify

  end

end #module
