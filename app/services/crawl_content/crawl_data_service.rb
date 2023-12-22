module CrawlContent
  class CrawlDataService < ApplicationService
    VALID_CONTENT_TYPE = %w(text/html application/json)
    attr_accessor :link, :template

    def initialize link, template
      @link = link
      @template = template
    end

    def call
      response = Request.new(link).get

      if response.nil?
        crawl_selenium
      else
        crawl_nokogiri response
      end
    end

    def crawl_nokogiri
      case response.content_type
      when "application/json"
        response.body
      when "text/html"
        return Crawler::NokogiriDriver::CrawlContent.new(response.body, template).run
      else
        raise "Response content_type must be application/json or text/html" unless VALID_CONTENT_TYPE.include?(response.content_type)
      end
    end

    def crawl_selenium
      Crawler::SeleniumDriver::CrawlContent.new(link, template).run
    end
  end
end
