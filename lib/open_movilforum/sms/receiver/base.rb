require 'observer'

module OpenMovilforum
  module SMS
    module Receiver
      # This is just the base-class, please check a subclass:
      # * OpenMovilforum::SMS::Receiver::Gmail
      class Base
        include Observable
        
        # Parses a message and notifies observers
        def received(message)
          message.gsub!(/\r/, '')
          message.scan(/^Movil: ?(.+)\nTexto: ?(.*)/) do |mvl, msg|
            mvl = mvl.split('')[2..-1].join('') if mvl =~ /^34\d+$/
            puts "Mensaje recibido"
            puts "  from: #{mvl}"
            puts "  msg: #{msg}"
            changed
            notify_observers(mvl, msg)
          end
        end
        
        def start
          raise "This method should be implemented in a subclass"
        end
      end
    end
  end
end