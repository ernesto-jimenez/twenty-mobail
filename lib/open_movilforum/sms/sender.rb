require 'net/http'
require 'uri'

module OpenMovilforum
  module SMS
    class Sender
      URL = 'https://opensms.movistar.es/aplicacionpost/loginEnvio.jsp'

      def initialize(login, password)
        @login = login.to_s
        @password = password.to_s
      end

      def send(number, message)
        number = number.to_s.strip
        raise ArgumentError, "Invalid phone: #{number}" unless number =~ /^\d+$/
        response = Net::HTTP.post_form(URI.parse(URL),
          {
            'TM_ACTION' => 'AUTHENTICATE',
            'TM_LOGIN' => @login,
            'TM_PASSWORD' => @password,
            'to' => number,
            'message' => message
          }
        )
        raise "SMS could not be sent: #{response.body}" unless response.body =~ /OK/
      end
    end
  end
end