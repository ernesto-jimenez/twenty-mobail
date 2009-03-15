server = OpenMovilforum::SMS::Receiver::POP3.new("server", SMS_RECEIVER_MAIL, SMS_RECEIVER_PASS)
server.add_observer(Process::Proxy)
keep_running(SMS_RECEIVER_SLEEP) do
  server.run_once
end
