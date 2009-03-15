require 'pop_ssl'
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
        def initialize(server, user, pass, sleep_time=60)
          @server = server
          @user = user
          @pass = pass
          self.sleep_time = sleep_time
        end

        def run_once
          Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
          Net::POP3.start(@server, 995, @user, @pass) do |pop|
            pop.each_mail do |m|
              msg = MailMessage.new(m.pop)
              self.received(msg.body)
              m.delete
            end
          end
        end

        def start
          loop do
            begin
              run_once
              sleep(sleep_time)
            rescue Exception => e
              puts [$!, e.backtrace].flatten.join("\n")
            end
          end
        end
      end
    end
  end
end
