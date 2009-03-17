require File.join(File.dirname(__FILE__), "../base")
require 'open_movilforum'
require 'tuenti'
require 'tuenti_credential'
require 'daemons'

create_dir(DAEMON_OPTIONS[:dir]) if DAEMON_OPTIONS[:dir]

Daemons.run_proc("img_publisher.rb", DAEMON_OPTIONS) do
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
        
        send_sms(phone, "Ya se ha publicado tu foto en Tuenti! :)")
        
        File.delete(img_path)
        log "Removed #{img_path}"
      elsif (Time.now - File.ctime(img_path)) > MMS_TIME_WAITING_FOR_CREDENTIALS
        log "Timeout (#{File.ctime(img_path).strftime("%y/%m/%d %H:%M:%S")}): removed #{img_path}"
        File.delete(img_path)
      end
    end
  end
end
