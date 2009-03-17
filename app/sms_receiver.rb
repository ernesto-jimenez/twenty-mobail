require File.join(File.dirname(__FILE__), "../base")
require 'open_movilforum'
require 'process'
require 'daemons'

create_dir(DAEMON_OPTIONS[:dir]) if DAEMON_OPTIONS[:dir]

server_type = ENV['SERVER_TYPE'] || 'gmail'
Daemons.run(File.join(File.dirname(__FILE__), "sms_receivers/#{server_type}.rb"), DAEMON_OPTIONS)
