require 'open_movilforum/mms/image_download'
require 'open_movilforum/mms/sender'

module OpenMovilforum
  module MMS
     # a message with an attachment to be sent
      class Message
        attr_reader :image, :text, :destination, :subject

        # constructor
        def initialize(dest, sub, img, txt)
          @image = img
          @subject = sub
          @text = txt
          @destination = dest
        end
      
        # to string (debug only)
        def to_s
          res = "TO: #{@destination}\n"
          res += "SUBJECT: #{@subject}\n"
          res += "ATTACHMENT: #{@image}\n"
          res += "BODY:\n#{@text}\n"
        
          return res
        end
      end
  end
end