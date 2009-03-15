require 'open_movilforum/sms/receiver/base'
require 'gserver'

module OpenMovilforum
  module SMS
    module Receiver
      class MailMessage
        attr_accessor :body, :headers
        def initialize(msg)
          msg.gsub!(/\r/, '')
          msg = msg.split("\n\n")
          self.headers = msg.shift
          self.body = msg.join("\n\n")
        end
      end
    end
  end
end
