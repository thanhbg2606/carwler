module Crawler

  module SeleniumDriver

    module Base
      attr_accessor :driver, :wait

      def create_driver headless = true, *args
        options = Selenium::WebDriver::Chrome::Options.new

        if headless
          options.add_argument('--headless')
          options.add_argument('--disable-dev-shm-usage')
          options.add_argument('--no-sandbox')
        end

        driver = Selenium::WebDriver.for :chrome, options: options
      end

      def create_wait
        wait = Selenium::WebDriver::Wait.new(:timeout => 3)
      end

      def css location, action
        driver.find_elements(:css, location).map{ |item| get_value(item, action) }
      end

      def at_css location, action
        element = driver.find_element(:css, location)
        get_value(element, action)
      end

      def close_driver
        driver.quit
      end

      private

      # Cần ghi log để check action nào đang không get được
      def get_value element, action
        if action.empty?
          action = "text"
        end

        element.attribute(action)
      rescue StandardError => e
        Rails.logger.error(e)
        nil
      end
    end
  end
end
