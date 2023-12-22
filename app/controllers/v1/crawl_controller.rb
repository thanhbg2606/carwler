module V1
  class CrawlController < ApplicationController
    def chapter
      result = CrawlContent::CrawlDataService.call(params[:link], params[:template])

      render json: { "data": result }, status: :ok
    end
  end
end
