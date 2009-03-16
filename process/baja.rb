require 'tuenti_credential'
require 'open_movilforum'

module Process
  class Baja
    def self.run(phone, msg)
      credentials = TuentiCredential.find_by_phone(phone)
      credentials.destroy if credentials
      
      sms_sender = OpenMovilforum::SMS::Sender.new(SMS_SENDER_PHONE, SMS_SENDER_PASS)
      sms_sender.send(phone, "Ya te hemos dado de baja! :)")
    end

    private :initialize
  end
end
