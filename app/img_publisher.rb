require File.join(File.dirname(__FILE__), "../base")
require 'open_movilforum'
require 'tuenti'
require 'tuenti_credential'
require 'daemons'

options = {
  :log_output => true,
  :backtrace  => true
}

Daemons.run_proc("img_publisher.rb", options) do
  create_dir(MMS_QUEUE_DIR)
  keep_running(IMG_PUBLISH_SLEEP) do
    Dir.glob("#{MMS_QUEUE_DIR}/*.*").sort.each do |img_path|
      data = img_path.split("/").reverse.first.split(".").first.split("_")
      
      timestamp = data[0].to_i
      phone = data[1]
      
      credentials = TuentiCredential.find_by_phone(phone)
      if credentials
        t = Tuenti.new(credentials.email, credentials.password)
        log "Uploading #{img_path}"
        t.upload_img(img_path)
        log "Uploaded #{img_path}"
        
        sms_sender = OpenMovilforum::SMS::Sender.new(SMS_SENDER_PHONE, SMS_SENDER_PASS)
        sms_sender.send(phone, "Ya se ha publicado tu foto en Tuenti! :)")
        
        File.delete(img_path)
        log "Removed #{img_path}"
      else
        log "No credentials for #{phone}"
      end
    end
  end
end
