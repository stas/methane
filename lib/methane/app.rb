require 'Qt4'
require 'qtwebkit'

module Methane
  
  # Main GUI class
  class App
    attr_accessor :app, :view

    # Build a new Qt window with a WebKit frame
    def self.start
      url = File.join(Methane.root, 'static', 'index.html')
      icon = File.join(Methane.root, 'static', 'img', 'methane.png')
      title = "Methane v.#{Methane::VERSION}"

      Methane::Notification.show(title, 'Started successfully')

      @app = Qt::Application.new([]) do
        @view = Qt::WebView.new
        # Load app into the frame
        @view.load Qt::Url.new("file://#{url}")
        # Set app icon
        @view.setWindowIcon(Qt::Icon.new(icon))
        @view.resize 600,800
        @view.show
        self.exec
      end
    end #start

  end

end #module
