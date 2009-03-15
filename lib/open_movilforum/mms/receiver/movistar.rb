require 'mechanize'

module OpenMovilforum
  module MMS
    module Receiver
      # MMS receiver through movistar website
      class Movistar
        SLEEP_TIME = 60
        
        def initialize(user, pass)
          @user = user
          @pass = pass
        end

        # performs a login into the movistar site
        def login
          begin
            # step 1. Go to the login page
            uri = URI.parse("http://www.multimedia.movistar.es/authenticate")
            @agent = WWW::Mechanize.new
            @agent.user_agent_alias = "Windows IE 7"
            @page = @agent.get(uri)

            # step 2. Fill the form
            form = @page.form("loginForm")
            form.TM_LOGIN = @user
            form.TM_PASSWORD = @pass
            @page = @agent.submit(form)
          rescue
            raise "Login failed"
          end
        end

        # downloads all messages and deletes them from the inbox
        def download_messages(dir)
          @page = @agent.get("http://www.multimedia.movistar.es/do/mail/folder/view?page=0&order=ascending&field=arrival")
          id = nil
          @page.parser.search('tr[@class="messagesList"]').each do |node|
            begin
              id = node['id']

              from = node.children[8].content.strip
              from = from[2, from.size-1] # remove international prefix


              file = @agent.get("/do/mail/message/viewAttachment?msgId=#{id}&part=2")
              
              if extension = file.filename.match(/\.(jpg|gif|jpeg|png)\"?$/)
                target_file = File.join(dir, "#{Time.now.to_i}_#{from}.#{extension[1]}")
                file.save_as(target_file)
              end
              
              @agent.post("/do/mail/message/delete?ref=list&deleteNow=true", {"msgIds" => id, "destfid" => "", "field" => "", "order" => "ascending"})
              
              yield(from) if block_given?
            rescue Exception => e
              puts "Error while processing a MMS"
              puts e.message
              e.backtrace.each do |line|
                puts "    #{line}"
              end
            end
          end
        end

        # processes all MMS
        def run_once(dir, &block)
          login
          download_messages(dir, &block)
        end

        # daemon
        def start(dir, &block)
          loop do
            run_once(dir, &block)
            sleep(SLEEP_TIME)
          end
        end

      end

    end
  end
end
