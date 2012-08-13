require 'curb'
require 'json'

class Campfire
  def search(page=0)
    call "#{base_url}search/fuck.json?n=#{page*50}"
  end

  def user(user_id)
    call "#{base_url}users/#{user_id}.json"
  end

  private ####################################################################

  def base_url
    "#{Fstats.config["protocol"]}://#{Fstats.config["subdomain"]}.campfirenow.com/"
  end

  def call(url)
    response = Curl.get(url) do |curl|
      curl.headers['Content-Type'] = "application/json"
      curl.username = Fstats.config["api_token"]
      curl.password = "X"
      curl.timeout = 10 # Seconds
    end
    JSON.parse(response.body_str)
  rescue Curl::Err::TimeoutError
    retry
  end
end
