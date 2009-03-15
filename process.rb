require 'base'

module Process
  class Proxy
    def self.update(sender, message)
      words = message.split(' ')
      process = words.shift
      message = words.join(' ')
      
      begin
        puts "Processing #{message}"
        get_class(process).run(sender, message)
      rescue Exception => e
        puts "=> Error on #{Time.now}"
        puts $!
        puts e.backtrace.join("\n")
      end
    end
    
    def self.get_class(class_name)
      unless /\A\w+\z/ =~ class_name
        raise NameError, "#{class_name.inspect} is not a valid constant name!"
      end
      
      require "process/#{class_name.downcase}"
      return contantize(class_name)
    end
    
    def self.contantize(class_name)
      Object.module_eval("::Process::#{class_name.capitalize}", __FILE__, __LINE__)
    end
  end
end
