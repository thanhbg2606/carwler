require 'uri'
require 'net/http'

class Request
  def initialize url, args = nil
    @uri = URI.parse(url)
    @args = args
  end

  def get
    response = Net::HTTP.get_response(@uri)

    return response if response.code == "200"
    raise "[#{@uri.to_s}]Response code #{response.code}: #{response.body}"
  rescue StandardError => e
    Rails.logger.error(e)
    nil
  end
end
