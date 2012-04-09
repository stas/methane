require 'tinder'
require 'eventmachine'

module Methane

  # A proxy to the Campfire API
  class Proxy
    attr_accessor :account, :rooms, :campfire

    # Handles instance calls
    def self.start(&blk)
      @@instance ||= self.new
      EM::run do
        @@instance.listen do |room, message|
          blk.call(room, message)
        end
      end
    end

    # Connects to Campfire API and gets user information and rooms details
    def initialize
      account_name = Methane.config.account
      auth = {
        :token => Methane.config.token
      }

      begin
        @campfire = Tinder::Campfire.new(account_name, auth)
        @account = @campfire.me
        @rooms = @campfire.rooms
        room_names = @rooms.collect{|r| r.name}.join(', ')
        Methane::Notification.show(
          'Authenticated!',
          "Joined #{room_names} as #{@account.name}."
        )
      rescue Tinder::AuthenticationFailed
        Methane::Notification.show(
          'Authentication failed!',
          'Please check the configuration file.'
        )
      end
    end

    # Listens to the Tinder Streaming API
    #
    # @returns [Room], [Hash] the message and it's room
    def listen
      last_message = {}
      if !@campfire.nil?
        @rooms.each do |room|
          room.listen do |message|
            # Skip if message gets repeated
            next if message.id <= last_message[room.id].to_i
            # Save last ok message id
            last_message[room.id] = message.id.to_i

            yield(room, message)
          end
        end
      end
    end

  end #class

end #module
