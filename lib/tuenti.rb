require 'rubygems'
require 'digest'
require 'mechanize'

class Tuenti
  attr_reader :user, :password
  def initialize(user, password)
    @user = user
    @password = password
  end

  def upload_img(img)
    agent, csfr = get_logged_in_agent_and_csfr
    respuesta = agent.post(upload_photo_url(csfr), 'func' => 'uploadq', 'upload' => '1', 'foto_0' => File.open(img))
    qid = respuesta.body.match(/window.parent.finish_upload\('[^']*', (\d+), \d\);/)[1]

    loop do
      reply = agent.get(check_queue_url(csfr, qid)).body
      break if reply =~ /'e'/
      #puts reply
      sleep(2)
    end
  end

  def set_status(status)
    agent, csfr = get_logged_in_agent_and_csfr
    agent.post(set_status_url(csfr), {'status' => status})
  rescue WWW::Mechanize::ResponseCodeError
  end
  
  def login?
    agent, reply = get_logged_in_agent_and_csfr
    return !reply.nil?
  end
  
  private 
  def get_logged_in_agent_and_csfr
    agent = WWW::Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
      if ENV['DEBUG']
        require 'logger'
        agent.log = Logger.new("mech.log")
      end
    }

    page = agent.get('http://www.tuenti.com')
    form = page.forms.first
    form.email = self.user
    form.md5 = Digest::MD5.hexdigest("#{form.timeStampSigned}#{Digest::MD5.hexdigest(self.password)}")
    form.tz = "1"
    form.remember = "0"

    form.submit

    csfr = agent.get('http://m.tuenti.com').body.match(/csfr=([a-z0-9]+)/)
    csfr = csfr[1] if csfr

    return agent, csfr
  end
  
  def upload_photo_url(csfr)
    "http://fotos.tuenti.com/?aj=&csfr=#{csfr}&if="
  end

  def check_queue_url(csfr, queue_id)
    "http://fotos.tuenti.com/?aj=&func=checkq&qid=#{queue_id}&csfr=#{csfr}&no_cache=#{(rand*1000000000000).ceil}"
  end

  def set_status_url(csfr)
    "http://m.tuenti.com/?m=profile&func=process_set_status&from=home&csfr=#{csfr}"
  end
end
