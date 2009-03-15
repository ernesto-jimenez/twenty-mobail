require File.join(File.dirname(__FILE__), "../base")
require 'open_movilforum'
require 'process'

# CREDENTIALS FOR MOVISTAR API FOR SENDING MMS
OpenMovilforum::MMS::Sender::Movistar::LOGIN[:user] = 660014962
OpenMovilforum::MMS::Sender::Movistar::LOGIN[:pass] = 293403

server = OpenMovilforum::SMS::Receiver::SMTP.new
server.add_observer(Process::Proxy)
server.start