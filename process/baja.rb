require 'tuenti_credential'
require 'open_movilforum'

module Process
  class Baja
    def self.run(phone, msg)
      credentials = TuentiCredential.find_by_phone(phone)
      credentials.destroy if credentials
      
      send_sms(phone, "Ya te hemos dado de baja! :)")
    end

    private :initialize
  end
end
