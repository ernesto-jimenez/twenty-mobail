require 'rubygems'
require 'mechanize'
require 'logger'

module Receiver
  class Movistar
    LOGIN = {
      :user => '630348665',
      :pass => '566843',
    }
    
    DIR = "/Users/temp/"
    def login
       # step 1. Go to the login page
        uri = URI.parse("http://www.multimedia.movistar.es/authenticate")
        @agent = WWW::Mechanize.new { |a| a.log = Logger.new("mech.log") }
        @agent.user_agent_alias = "Windows IE 7"
        @page = @agent.get(uri)
        
        # step 2. Fill the form
        form = @page.form("loginForm")
        form.TM_LOGIN = LOGIN[:user]
        form.TM_PASSWORD = LOGIN[:pass]
        @page = @agent.submit(form)        
    end
    
    def download_messages
      @page = @agent.get("http://www.multimedia.movistar.es/do/mail/folder/view?page=0&order=ascending&field=arrival")
      id = nil
      @page.parser.search('tr[@class="messagesList"]').each do |node|
        id = node['id']
       
        from = node.children[8].content.strip
        from = from[2, from.size-1] # remove international prefix
        
    
        file = @agent.get("/do/mail/message/viewAttachment?msgId=#{id}&part=2")
        file.save_as(DIR + Time.now.to_i.to_s + "_" + from + "." + file.filename.match(/\.jpg|gif|jpeg|png\"?$/)[0].delete("\"")) if file.filename.match(/\.jpg|gif|jpeg|png\"?$/)
        @agent.post("/do/mail/message/delete?ref=list&deleteNow=true", {"msgIds" => id, "destfid" => "", "field" => "", "order" => "ascending"})    
      end
    end
    
    def process
      login
      download_messages
    end

  end
  
end

wa = Receiver::Movistar.new
wa.process
