require 'selenium-webdriver'

module Carwler

  module SeleniumDriver

    module Base
      attr_reader :driver

      def self.create_driver headless = false, *args
        options = Selenium::WebDriver::Chrome::Options.new

        if headless
          options.add_argument('--headless')
        end

        driver = Selenium::WebDriver.for :chrome, options: options
        wait = Selenium::WebDriver::Wait.new(:timeout => 5)
        [driver, wait]
      end

      def self.close_driver
        driver.quit
      end
    end
  end
end
