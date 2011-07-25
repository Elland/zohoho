module Zohoho 
  require 'httparty'
  require 'json'

  class Recruit
    include HTTParty
    
    def initialize(username, password, apikey)
      @conn = Zohoho::Connection.new 'zohopeople', username, password, apikey
    end
    
    def auth_url
      @conn.ticket_url
    end
    
    def candidates_url
      "http://recruit.zoho.com/ats/private/json/Candidates/getRecords?apikey=#{@conn.api_key}&ticket=#{@conn.ticket}"
    end
    
    def get_candidates(conditions = {})
      url = conditions.empty? ? candidates_url : to_url_params(candidates_url)
      self.class.get url
    end
    
    
    private
    
    def to_url_params(url)
      @url = "&"
      url.each_pair do |k, v|
        @url += "#{k}=#{v}&"
      end
      @url
    end
  end
end