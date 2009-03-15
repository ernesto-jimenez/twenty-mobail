server = OpenMovilforum::SMS::Receiver::SMTP.new
server.add_observer(Process::Proxy)
server.start
