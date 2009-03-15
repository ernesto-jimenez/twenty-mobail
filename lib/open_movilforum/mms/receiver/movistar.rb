require 'mechanize'

module OpenMovilforum
  module MMS
    module Receiver
      # MMS receiver through movistar website
      class Movistar
        LOGIN = {
          :user => '630348665',
          :pass => '566843',
        }
        
        # folder in which images will be stored
        DIR = "/Users/temp/"
        
        SLEEP_TIME = 60
        
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
            form.TM_LOGIN = LOGIN[:user]
            form.TM_PASSWORD = LOGIN[:pass]
            @page = @agent.submit(form)
          rescue
            raise "Login failed"  
          end    
        end

        # downloads all messages and deletes them from the inbox
        def download_messages
          @page = @agent.get("http://www.multimedia.movistar.es/do/mail/folder/view?page=0&order=ascending&field=arrival")
          id = nil
          @page.parser.search('tr[@class="messagesList"]').each do |node|
            begin
              id = node['id']

              from = node.children[8].content.strip
              from = from[2, from.size-1] # remove international prefix


              file = @agent.get("/do/mail/message/viewAttachment?msgId=#{id}&part=2")
              file.save_as(DIR + Time.now.to_i.to_s + "_" + from + "." + file.filename.match(/\.jpg|gif|jpeg|png\"?$/)[0].delete("\"")) if file.filename.match(/\.jpg|gif|jpeg|png\"?$/)
              @agent.post("/do/mail/message/delete?ref=list&deleteNow=true", {"msgIds" => id, "destfid" => "", "field" => "", "order" => "ascending"})  
            rescue
              raise "Error while processing a MMS"  
            end  
          end
        end

        # processes all MMS
        def run_once
          login
          download_messages
        end
        
        # daemon
        def start
          loop do
            run_once
            sleep(SLEEP_TIME)
          end
        end

      end

    end
  end
end
