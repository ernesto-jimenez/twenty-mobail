require 'net/smtp' 

from = 'tests@testing.com'
to = 'test.openmovilforum@gmail.com'
Net::SMTP.start('localhost', 25) do |smtp|
  smtp.open_message_stream(from, [to]) do |f|
    f.puts "From: #{from}"
    f.puts "To: #{to}"
    f.puts 'Subject: test message'
    f.puts
    f.puts "Movil: #{ARGV[0]}"
    f.puts "Texto: #{ARGV[1]}"
  end
end
