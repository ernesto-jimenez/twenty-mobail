require 'open_movilforum/sms/receiver/base'
require 'open_movilforum/sms/receiver/mail_message'
require 'gserver'

module OpenMovilforum
  module SMS
    module Receiver
      class SMTP < OpenMovilforum::SMS::Receiver::Base
        def start
          a = SMTPServer.new(self, 25)
          a.start
          a.join
        end
        
        def run_once
          a = SMTPServer.new(self, 25, 1)
          a.start
          a.join
        end
      end


      class SMTPServer < GServer
        attr_accessor :observable
        def initialize(observable, port=25, limit=-1)
          super(port)
          self.observable = observable
          @count = limit
        end

        def serve(io)
          @data_mode = false
          puts "Connected"
          io.print "220 hello\r\n"
          loop do
            if IO.select([io], nil, nil, 0.1)
              data = io.readpartial(4096)
              ok, op = process_line(data)
              break unless ok
              puts "<< #{op.inspect}"
              io.print op
            end
            break if io.closed?
          end
          io.print "221 bye\r\n"
          puts "<< 221 bye"
          io.close
          
          msg = MailMessage.new(@data)
          self.observable.received(msg.body)
          @count -= 1 
          stop if @count.zero?
        end
        
        def process_line(line)
          puts ">> #{line.inspect}"
          if (line =~ /^(HELO|EHLO)/)
            return true, "220 and..?\r\n"
          end
          if (line =~ /^QUIT/)
            return false, "bye\r\n"
          end
          if (line =~ /^MAIL FROM\:/)
            return true, "220 OK\r\n"
          end
          if (line =~ /^RCPT TO\:/)
            return true, "220 OK\r\n"
          end
          if (line =~ /^DATA/)
            @data_mode = true
            @data = ''
            return true, "354 Enter message, ending with \".\" on a line by itself\r\n"
          end
          if (@data_mode) && (line.chomp =~ /^.$/)
            @data += line.chomp.gsub(/^.$/, '')
            @data_mode = false
            return true, "220 OK\r\n"
          end
          if @data_mode
            @data += line
            return true, ""
          else
            return true, "500 ERROR\r\n"
          end
        end
      end
    end
  end
end
