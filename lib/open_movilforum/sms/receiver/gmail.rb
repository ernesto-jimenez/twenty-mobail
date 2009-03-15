require 'gmailer'
require 'open_movilforum/sms/receiver/base'

module OpenMovilforum
  module SMS
    module Receiver
      # class Prueba
      #   def self.update(sender, message)
      #     puts "Recibioms: #{message.inspect} de: #{sender}"
      #   end
      # end
      # 
      # server = OpenMovilforum::SMS::Receiver::Gmail.new('user','pass')
      # server.add_observer(Prueba)
      # server.start
      class Gmail < OpenMovilforum::SMS::Receiver::Base
        attr_accessor :sleep_time
        def initialize(user, pass, sleep_time=60)
          @user = user
          @pass = pass
          self.sleep_time = sleep_time
        end
        
        def run_once
          GMailer.connect(@user, @pass) do |g|
            g.messages(:label => "inbox", :read => false) do |ml|
              ml.each_msg do |conversation|
                self.received conversation.body.gsub(/<[^>]+>/, '')
                conversation.mark_read
              end
            end
          end
        end

        def start
          loop do
            run_once
            sleep(sleep_time)
          end
        end
      end
    end
  end
end
