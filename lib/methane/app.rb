require 'Qt4'
require 'qtwebkit'

module Methane
  
  # Main GUI class
  class App
    attr_accessor :app

    @instance

    # App spawner
    def self.start
      # Do not spawn new instances
      return if !@instances.nil?

      title = "Hello from Methane v.#{Methane::VERSION}"
      Methane::Notification.show(title, Methane.config.messages.join("\n"))

      # Stop here if config is invalid
      return if Methane.config.account.nil? or Methane.config.token.nil?

      # Spawn the app
      @instance ||= self.new
      @instance.build_app
      @instance.app.exec
    end #start

    # Builds a Qt window with a WebKit frame
    #
    # Separated mostly for testing purposes
    def build_app
      root = Methane.root || ''
      url = File.join(root, 'static', 'index.html')
      icon = File.join(root, 'static', 'img', 'methane.png')
      @app = Qt::Application.new([]) do
        @view = Qt::WebView.new
        # Load app into the frame
        @view.load Qt::Url.new("file://#{url}")
        # Set app icon
        @view.setWindowIcon(Qt::Icon.new(icon))
        # Set title
        Qt::Object.connect(
          @view, SIGNAL( 'titleChanged(const QString&)' ),
          @view, SLOT( 'setWindowTitle(const QString&)' )
        )
        # Disable mouse right click menus
        @view.setContextMenuPolicy(Qt::NoContextMenu)
        @view.resize 600,800
        @view.show
      end
    end

  end

end #module
