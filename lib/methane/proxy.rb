require 'tinder'

module Methane

  # A proxy to the Campfire API
  class Proxy
    class << self
      attr_accessor :account, :rooms, :campfire
    end

    # Handles room publication
    #
    # @param [Fixnum] room_id, the room id
    # @param [String] message, the message to send
    def self.speak(room_id, message)
      self.connect

      return if self.campfire.nil? or room_id.class != Fixnum

      room = self.campfire.find_room_by_id(room_id)
      message.strip!
      tweet = message.match(/^https?.+twitter.com.#!.[a-zA-Z0-9]+.status.\d+$/)

      room.tweet(message) if !tweet.nil?
      room.paste(message) if message.size > 180
      room.speak(message) if !paste
    end

    # Connects to Campfire API and gets user information and rooms details
    def self.connect
      return self if !self.campfire.nil?

      account_name = Methane.config.account
      token = Methane.config.token
      
      begin
        self.campfire = Tinder::Campfire.new(account_name, :token => token)
        self.account = self.campfire.me
        self.rooms = self.campfire.rooms
        room_names = self.rooms.collect{|r| r.name}.join(', ')
        Methane::Notification.show(
          'Authenticated!',
          "Joined #{room_names} as #{self.account.name}."
        )
      rescue Tinder::AuthenticationFailed
        Methane::Notification.show(
          'Authentication failed!',
          'Please check the configuration file.'
        )
      end
    end

  end #class

end #module
