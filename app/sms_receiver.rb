require File.join(File.dirname(__FILE__), "../base")
require 'open_movilforum'
require 'process'
require 'daemons'

server_type = ENV['SERVER_TYPE'] || 'gmail'
options = {
  :log_output => true,
  :backtrace  => true
}
Daemons.run(File.join(File.dirname(__FILE__), "sms_receivers/#{server_type}.rb"), options)
