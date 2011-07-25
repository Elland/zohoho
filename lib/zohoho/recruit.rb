module Zohoho 
  require 'httparty'
  require 'nokogiri'
  require 'json'

  class Recruit
    include HTTParty
    
    def initialize(username, password, apikey, type = 'json')
      @type = type
      @conn = Zohoho::Connection.new 'zohopeople', username, password, apikey
    end
    
    def auth_url
      @conn.ticket_url
    end
    
    def candidates_url(type = @type)
      "http://recruit.zoho.com/ats/private/#{type}/Candidates/getRecords?apikey=#{@conn.api_key}&ticket=#{@conn.ticket}"
    end
    
    def get_candidates(conditions = {})
      (@type == 'json' ? JSON.parse(self.class.get(candidates_url, conditions)) : Nokogiri::XML.parse(self.class.get(candidates_url, conditions)))
    end
    
    def candidates(conditions = {})
      @candidates ||= get_candidates
    end
    
    def get_parsed_candidates(conditions = {:toIndex => 200})
      raw_candidates = candidates
      @candidates = raw_candidates["response"]["result"]["Candidates"]["row"]
      
      #extracts the relevant data
      @candidates.collect! do |candidate|
        @hash = {}
        candidate["FL"].collect do |pair|
          pair = pair.to_a
          @hash[pair.last.last.to_sym] = pair.first.last
        end
        @hash
      end
    end
  end
end