module V1
  class CrawlController < ApplicationController
    def chapter
      res = Crawler::NokogiriDriver::CrawlContent.new(params[:link], params[:template]).run

      render json: { "data": res }, status: :ok
    end
  end
end
