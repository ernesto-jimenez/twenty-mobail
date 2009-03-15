require 'open_movilforum/mms/sender/gmail'
require 'open_movilforum/mms/sender/movistar'

module OpenMovilforum
  module MMS
    module Sender
      class Base
        def self.send(user, search, map_url, msg_text)
          if (user =~ /^\d+$/)
            OpenMovilforum::MMS::Sender::Movistar.send(user, search, map_url, msg_text)
          else
            OpenMovilforum::MMS::Sender::Gmail.send(user, search, map_url, msg_text)
          end
        end
      end
    end
  end
end