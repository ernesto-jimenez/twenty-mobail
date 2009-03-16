GEMS = {
  'mechanize'    => ">= 0.9.2",
  'gmailer'      => "0.2.1",
  'daemons'      => "1.0.10",
  'sqlite3-ruby' => "1.2.4",
  'nokogiri'     => "1.2.2",
  'activerecord' => "> 2.0",
  'hoe'          => ">= 1.9.0"
}

def try_gem(gem_name, version, print=true)
  print "Checking #{gem_name} version #{version}: " if print
  begin
    gem gem_name, version
  rescue Exception
    puts "FAIL" if print
    return false
  end
  puts "OK" if print
  return true
end

begin
  require 'rubygems'
rescue Exception
  STDERR.puts "You need to install rubygems.\ncheck http://docs.rubygems.org/"
  exit(false)
end

pending_to_install = []
GEMS.each do |gem_name, version|
  pending_to_install << "sudo gem install #{gem_name} -v \"#{version}\"" unless try_gem(gem_name, version)
end

puts ""
if pending_to_install.empty?
  puts "Everything OK. Your environment is ready"
else
  STDERR.puts "You need to install some gems, type in your terminal:"
  pending_to_install.each do |msg|
    STDERR.puts msg
  end
end
