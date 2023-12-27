module V1
  class CrawlController < ApplicationController
    def chapter
      result = CrawlContent::CrawlDataService.call(params[:link], params[:template])

      render json: { "data": result }, status: :ok
    rescue Selenium::WebDriver::Error::TimeoutError => e
      Rails.logger.error(e.message)
      render json: { "error": e.message }, status: :bad_request
    end
  end
end
