require 'gmailer'
require 'digest/md5'
require 'open_movilforum/mms/image_download'

module OpenMovilforum
  module MMS
    module Sender
      # a MMS sender
      class Gmail
        LOGIN = {
          :user => 'test.openmovilforum',
          :pass => '12341234',
        }
        
        # send the message with a GIF attachment to the recipient
        def self.send(to, subject, image, body)
          # Build message
          msg = Message.new(to, subject, image, body)
          
          # download attached map
          file = "#{Digest::MD5.hexdigest(image)}.gif"
          OpenMovilforum::MMS::ImageDownload.download(msg.image, file)
        
          puts "Connecting to " + LOGIN[:user] + "@gmail.com..."
          # send e-mail
          GMailer.connect(LOGIN[:user], LOGIN[:pass]) do |g|
            g.send(
              :to => msg.destination,
              :subject => msg.subject,
              :body => msg.text,
              :files => [file]
            )          
          end
          puts "E-mail sent to #{msg.destination}"
        
          # delete attached map
          File.delete(file) if File.exists?(file)
        end
  
      end

    end
  end
end