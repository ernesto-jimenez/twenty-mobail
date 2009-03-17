require 'rubygems'
require File.join(File.dirname(__FILE__), 'config/constants')

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), 'app')
$LOAD_PATH << File.dirname(__FILE__)

def create_dir(path)
  dirs = []
  until File.exists?(path)
    dirs << path
    path = File.dirname(path)
  end
  dirs.reverse.each do |dir|
    Dir.mkdir(dir, 0770)
  end
end

def keep_running(sleep_timer, &block)
  loop do
    #log "Running..."
    begin
      yield
    rescue Exception => e
      log "Exception caught!"
      puts e.message
      e.backtrace.each do |line|
        puts "    #{line}"
      end
      puts "\n\n"
    end
    #log "Ended, sleep #{sleep_timer} seconds"
    sleep(sleep_timer)
  end
end

def log(msg)
  puts "[#{Time.now.strftime("%y/%m/%d %H:%M:%S")}] #{msg}"
end

require 'open_movilforum'
def send_sms(phone, msg)
  @sms_sender ||= OpenMovilforum::SMS::Sender.new(SMS_SENDER_PHONE, SMS_SENDER_PASS)
  @sms_sender.send_sms(phone, msg)
  log "SMS SENT: #{phone.inspect}, #{msg.inspect}"
rescue => e
  log "=> SMS NOT SENT! #{phone.inspect}, #{msg.inspect}"
  raise e
end
