require 'tuenti'
require 'tuenti_credential'
require 'open_movilforum'

module Process
  class Estoy
    def self.run(phone, status)
      credentials = TuentiCredential.find_by_phone(phone)
      if credentials
        t = Tuenti.new(credentials.email, credentials.password)
        log "Setting status #{status}"
        t.set_status(status)
        log "Status setted #{status}"
        
        send_sms(phone, "Ya se ha cambiado tu estado! :)")
      else  
        send_sms(phone, "No podemos cambiar tu estado hasta que des de alta tu cuenta en tuenti. Envía un sms a #{SMS_RECEIVER_PHONE} con: ALTA tu-email-en-tuenti tu-clave-de-tuenti")
        log "No credentials for #{phone}, user notified"
      end
    end

    private :initialize
  end
end
