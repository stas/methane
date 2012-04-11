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

    def decode_encode(obj)
      # Encode
      return obj.to_json if obj.class != String
      # Encode
      return Hashie::Mash.new(MultiJson.decode(obj))
    end

    # Starts the websocket
    def start_websocket
      EventMachine::WebSocket.start(@options) do |ws|

        sid = @channel.subscribe do |msg|
          puts "Message received: #{msg}" if Methane.debug

          ws.send(msg)
          message = decode_encode(msg)

          # If it's our message, ignore
          next if message.user.id == Methane::Proxy.account.id

          # Else notify this
          room = Methane::Proxy.campfire.find_room_by_id(message.room_id)
          title = "#{message.user.name} in #{room.name}"

          Methane::Notification.show(title, message.body)
        end

        ws.onopen do
        end

        ws.onmessage do |msg|
          if msg.match(/!rooms/)
            # Send the list of rooms
            ws.send decode_encode(
              :account => Methane::Proxy.account,
              :rooms => Methane::Proxy.rooms
            )
          else
            ws.send(msg)
          end #if
        end

        ws.onclose { @channel.unsubscribe(sid) }
      end

      puts "WebSocket started with #{@options.inspect}" if Methane.debug
    end

    # Starts a notifier
    def start_notifier

      last_message = {}

      Methane::Proxy.rooms.each do |room|
        room.listen do |message|
          # Skip if message gets repeated
          next if message.id <= last_message[room.id].to_i

          # Skip if message is empty
          next if message.body.nil? or message.user.nil?

          # Save last ok message id
          last_message[room.id] = message.id.to_i

          @channel.push decode_encode(message)
        end
      end
    end

  end

end #module
