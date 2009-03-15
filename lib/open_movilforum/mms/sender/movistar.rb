require 'digest/md5'
require 'mechanize'
require 'open_movilforum/mms/image_download'

## ATENCIÓN
# MOVISTAR CAMBIÓ SU WEB A MITAD DEL CONCURSO Y LA API DE OPEN MOVIL FORUM YA NO
# FUNCIONA.
# NO HEMOS PODIDO REFACTORIZAR ESTE CÓDIGO PORQUE LA APLICACIÓN NOS DABA MUCHOS
# ERRORES 500, ASÍ QUE HEMOS TENIDO QUE DEJAR EL CÓDIGO CUTRE Y SUCIO QUE SALIÓ
# DE DARSE DE CABEZAZOS CONTRA LA WEB

module OpenMovilforum
  module MMS
    module Sender
      # Movistar MMS Sender
      class Movistar
        LOGIN = {
          :user => '660014962',
          :pass => '293403',
        }
        
        def send(msg)
            # download attached map
            #@file = Digest::MD5.hexdigest(msg.image) + ".gif"
            #OpenMovilforum::MMS::ImageDownload.download(msg.image, @file)
            @file = msg.image
            
            @msg = msg            
            
            puts "Login @ movistar..."
            self.login
            puts "Building message..."
            self.build
            puts "Sending message..."
            
            form = @page.forms.name("mmsForm").first
            @page = @agent.submit(form)
            
            #debugger
            
            puts "Message sent"
        end
        
        def login
          # step 1. Go to the login page
          uri = URI.parse("http://www.multimedia.movistar.es/authenticate")
          @agent = WWW::Mechanize.new
          @agent.user_agent_alias = "Windows IE 7"
          @page = @agent.get(uri)
          
          # step 2. Fill the form
          form = @page.forms.name("loginForm").first
          form.TM_LOGIN = LOGIN[:user]
          form.TM_PASSWORD = LOGIN[:pass]
          @page = @agent.submit(form)        
          
          # step 3. Create a new message
          @page = @agent.get("/do/multimedia/create?l=sp-SP&v=mensajeria")
        end
        
        def build()   
          # fill text fields
          
          page = @agent.get("/do/multimedia/upload?l=sp-SP&v=mensajeria")
          form_upload = page.forms.name('mmsComposerUploadItemForm').first
          form_upload.file_uploads.first.file_name = @file
          #form_upload.file_uploads.first.value = File.read(@file)
          #form_upload.file_uploads.first.mime_type = 'image/gif'
          #form_upload.action = "/do/multimedia/uploadEnd"
          
          result = @agent.submit(form_upload)
          
          #@page = @agent.post('http://multimedia.movistar.es/do/multimedia/show') 
          form = @page.forms.name("mmsForm").first
          @page = @agent.submit(form)
          form = @page.forms.name("mmsForm").first
          form.to = @msg.destination   
          form.subject = @msg.subject
          form.text = @msg.text
          form.action = "/do/multimedia/send?l=sp-SP&v=mensajeria"
        end
        
        # send the message with a GIF attached
        def self.send(to, subject, image, body)
            # Build message object
            
            file = "#{Digest::MD5.hexdigest(image)}.gif"
            OpenMovilforum::MMS::ImageDownload.download(image, file)
            msg = Message.new(to, subject, file, body)
            
            movi = Movistar.new().send(msg)
            
            # delete attached map
            File.delete(file) if File.exists?(file)
        end
        
      end
    end
  end
end