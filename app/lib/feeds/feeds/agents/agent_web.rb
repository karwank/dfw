require 'httparty'

module Feeds
  
  module AgentWeb

    def configure options = {}
      @options = options.transform_keys(&:to_sym)
    end

    def retrieve! url
      
      response = begin
        HTTParty.get url
      rescue => e
        raise Feeds::WebCommunicationError.new(e.message)
      end

      case response.code.to_i
      when 200
        response.body
      when 404
        raise Feeds::FeedNotFound.new("Resource #{url} not found")
      end

    end

  end


  # Exception raised when HTTP request failed
  class WebCommunicationError < Error; end

end
