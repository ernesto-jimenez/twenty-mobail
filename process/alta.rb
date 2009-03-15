require 'tuenti'
require 'tuenti_credential'
require 'open_movilforum'
require 'email_address'

module Process
  class Alta
    def self.run(phone, msg)
      msg = msg.split(" ")
      email = msg.shift
      password = msg.join(" ")
      
      sms_sender = OpenMovilforum::SMS::Sender.new(SMS_SENDER_PHONE, SMS_SENDER_PASS)
      
      if email.empty? || password.empty?
        sms_sender.send(phone, "Tienes que enviar el email y la clave de tu cuenta en Tuenti al numero #{SMS_RECEIVER_PHONE}: ALTA tu-email-en-tuenti tu-clave-de-tuenti")
      elsif !(email =~ EmailAddress::RegExp)
        sms_sender.send(phone, "El email que has enviado (#{email}) no es un email valido. Envia al numero #{SMS_RECEIVER_PHONE}: ALTA tu-email-en-tuenti tu-clave-de-tuenti")
      else
        begin
          credentials = TuentiCredential.find_or_initialize_by_phone(phone)
          credentials.email = email
          credentials.password = password
          credentials.save!
          sms_sender.send(phone, "Ya estas dado de alta! :) Puedes publicar tus fotos enviandolas por MMS numero #{MMS_RECEIVER_PHONE}")
          sms_sender.send(phone, "Puedes cambiar tu estado enviando un SMS al numero #{SMS_RECEIVER_PHONE} con: ESTOY tu nuevo estado")
          sms_sender.send(phone, "Puedes darte de baja enviando un SMS al numero #{SMS_RECEIVER_PHONE} con la palabra BAJA")
        rescue
          sms_sender.send(phone, "No hemos podido darte de alta :( prueba de nuevo enviando al numero #{SMS_RECEIVER_PHONE}: ALTA tu-email-en-tuenti tu-clave-de-tuenti")
        end
      end
    end

    private :initialize
  end
end
