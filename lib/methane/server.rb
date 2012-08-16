require 'em-websocket'
require 'hashie'

module Methane

  # Provides the websocket server and notifications runner
  class Server

    # Builds the websocket and starts the Notification
    def initialize

      @channel = EM::Channel.new
      @options = {
        :host => Methane.config.raw['campfire']['ws_host'] || '0.0.0.0',
        :port => Methane.config.raw['campfire']['ws_port'] || 20022,
        :debug => Methane.debug
      }

      Methane::Proxy.connect

      EM::run do
        start_websocket
        start_notifier

        trap(:INT) do
          Methane::Proxy.rooms.each do |room|
            room.leave
          end
          EM.stop if EM.reactor_running? 
        end
      end #EM::run

    end #start


    # Handles two message format
    #
    # If message comes from WebSocket we need to Hashify it
    # If message is an object, we need to stringify to JSON
    def decode_encode(obj)
      # Encode
      return obj.to_json if obj.class != String
      # Encode
      return Hashie::Mash.new(MultiJson.decode(obj))
    end

    # Starts the websocket
    def start_websocket
      EventMachine::WebSocket.start(@options) do |ws|

        # Once the client connected
        ws.onopen {

          # Subscribe it
          sid = @channel.subscribe { |msg| ws.send(msg) }

          # When a new message is received through socket
          ws.onmessage do |msg|
            if msg.match(/^!connection$/)
              # Send the connection details
              ws.send decode_encode( :connection => {
                :rooms => fetch_rooms,
                :account => Methane::Proxy.account
              })
            else
              ws.send(msg)
            end #if
          end

          # When client disconnected, unsubscribe it
          ws.onclose { @channel.unsubscribe(sid) }

        } # onopen

      end

      puts "WebSocket started with #{@options.inspect}" if Methane.debug
    end

    # Load basic details about rooms
    def fetch_rooms
      @rooms ||= []
      return @rooms unless @rooms.empty?
      Methane::Proxy.rooms.each do |room|
        @rooms << {
          :id => room.id,
          :name => room.name,
          :topic => room.topic,
          :presence => room.presence,
          :recent => room.recent(1)
        }
      end

      return @rooms
    end

    # Starts a notifier
    def start_notifier

      last_message = {}

      Methane::Proxy.rooms.each do |room|
        room.listen do |message|
          puts "Received: #{message.inspect}" if Methane.debug

          # Skip if message gets repeated
          next if message.id != last_message[room.id].to_i

          # Skip if message is empty
          next if message.body.nil? or message.user.nil?

          # Save last ok message id
          last_message[room.id] = message.id.to_i

          # Cast it!
          @channel.push decode_encode(message)
          try_notification(message)

        end
      end
    end

    # Sends a notification if message is not ours
    #
    # @param message [Hash]
    def try_notification(message)
      # If it's our message, ignore
      return if message.user.id == Methane::Proxy.account.id

      # Else notify this
      room = Methane::Proxy.campfire.find_room_by_id(message.room_id)
      title = "#{message.user.name} in #{room.name}"

      Methane::Notification.show(title, message.body)
    end
  end

end #module
