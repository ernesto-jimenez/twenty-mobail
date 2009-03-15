require 'net/http'
require 'uri'

module OpenMovilforum
  module MMS
    # an image downloader
    class ImageDownload
      # download the file to the given path
      def self.download(url, file_path)
        body = self.fetch(url)
        file = File.new(file_path, 'w')
        file.write(body)
        file.close
      end
    
      private :initialize
    
    private
      # try to fetch URL
      def self.fetch(uri_str, limit = 10)
        # You should choose better exception.
        raise ArgumentError, 'HTTP redirect too deep' if limit == 0

        response = Net::HTTP.get_response(URI.parse(uri_str))
        case response
        when Net::HTTPSuccess     then response.body
        when Net::HTTPRedirection then fetch(response['location'], limit - 1)
        else
          raise ArgumentError, "Couldn't get image"
        end
      end
    end
  end
end