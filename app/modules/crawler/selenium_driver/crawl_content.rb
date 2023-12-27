module Crawler

  module SeleniumDriver

    class CrawlContent
      include Base
      attr_accessor :link, :params, :result

      def initialize link, params
        @link = link
        @params = params
        @result = Hash.new
        @driver = create_driver
        @wait = create_wait
      end

      def run
        driver.navigate.to link
        analysis_content
      end

      private

      def analysis_content
        params.each do |key, arr_value|
          location = arr_value[0]
          action = arr_value[1]

          if key.include?("array")
            result[key] = wait.until { css(location, action) }
          else
            result[key] = wait.until { at_css(location, action) }
          end
        end
        result
      rescue Selenium::WebDriver::Error::TimeoutError => e
        Rails.logger.error(e.message)
      ensure
        close_driver
      end
    end

  end

end
