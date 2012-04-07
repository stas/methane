module Methane

  # Dinamycally handles notifications for Methane
  #
  # Right now supports:
  # * Libnotify (Linux)
  class Notification
    @instance

    # Static method to call to send a notification
    #
    # Should detect and load appropriate gem
    # On success calls the proper method to create the notification
    # @see `libnotify` method below
    def self.show(title, body, timeout=nil, icon=nil)
      @instance ||= self.new
      begin
        @instance.libnotify(title, body, timeout, icon)
      rescue LoadError
      end
    end

    # Handles Libnotify notifications
    #
    # @title, [String] the notification title
    # @body, [String] the notification text
    # @timeout, [Fixnum] seconds it should persist, defaults to 1.5
    # @icon, [Symbol] the icon title
    def libnotify(title, body, timeout=1.5, icon=nil)
      require 'libnotify'
      icon ||= 'emblem-default'.to_sym
      Libnotify.show(
        :summary    => title,
        :body       => body,
        :timeout    => 1.5,
        :icon_path  => icon
      )
    end #notify

  end

end #module
