require 'rubygems'
require 'daemons'

server_type = ENV['SERVER_TYPE'] || 'smtp'
options = {
  :log_output => true,
  :backtrace  => true
}
Daemons.run(File.join(File.dirname(__FILE__), "servers/#{server_type}.rb"), options)