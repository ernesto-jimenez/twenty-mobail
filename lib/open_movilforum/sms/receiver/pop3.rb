require 'net/pop'
require 'open_movilforum/sms/receiver/base'
require 'open_movilforum/sms/receiver/mail_message'

module OpenMovilforum
  module SMS
    module Receiver
      # class Prueba
      #   def self.update(sender, message)
      #     puts "Recibioms: #{message.inspect} de: #{sender}"
      #   end
      # end
      # 
      # server = OpenMovilforum::SMS::Receiver::POP3.new('user','pass')
      # server.add_observer(Prueba)
      # server.start
      class POP3 < OpenMovilforum::SMS::Receiver::Base
        attr_accessor :sleep_time
        def initialize(user, pass, sleep_time=60)
          @user = user
          @pass = pass
          self.sleep_time = sleep_time
        end
        
        def run_once
          pop = Net::POP3.new('pop.example.com')
          pop.start('YourAccount', 'YourPassword')
          pop.each_mail do |m|
            msg = MailMessage.new(m.pop)
            self.received(msg.body)
            m.delete
          end
          pop.finish
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

    