require File.join(File.dirname(__FILE__), "../base")
require 'open_movilforum'
require 'tuenti_credential'
require 'daemons'

create_dir(DAEMON_OPTIONS[:dir]) if DAEMON_OPTIONS[:dir]

Daemons.run_proc("mms_receiver.rb", DAEMON_OPTIONS) do
  create_dir(MMS_QUEUE_DIR)
  
  mms_receiver = OpenMovilforum::MMS::Receiver::Movistar.new(MMS_RECEIVER_PHONE, MMS_RECEIVER_PASS)
  keep_running(MMS_RECEIVER_SLEEP) do
    mms_receiver.run_once(MMS_QUEUE_DIR) do |phone|
      credentials = TuentiCredential.find_by_phone(phone)
      log "MMS from #{phone}"
      unless credentials
        send_sms(phone, "Hemos recibido tu imagen. Para publicarla en tuenti envia un sms a #{SMS_RECEIVER_PHONE} con: ALTA tu-email-en-tuenti tu-clave-de-tuenti")
        log "No credentials for #{phone}, user notified"
      end
    end
  end
end
