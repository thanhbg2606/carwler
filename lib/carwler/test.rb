require 'selenium-webdriver'
require 'csv'
require 'pry'

def handler_selenium(url, &block)
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.navigate.to url
  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # Increased timeout

  yield driver, wait
  driver.quit
end

$log = File.open("carwler.log", 'a')

list_link_story = [
  "https://truyenchu.vn/toan-tri-doc-gia-app",
  "https://truyenchu.vn/do-thi-cuc-pham-y-than",
  "https://truyenchu.vn/nghich-thien-chi-ton"
]

def run link_story
  file_name = link_story.split("/").last
  file = CSV.open("#{file_name}.csv", 'w')
  $log.puts("[INFO][#{Time.now}][#{link_story}] Carwling")

  handler_selenium(link_story) do |driver, wait|
    count = 0
    navigate_first_chapter = driver.find_element(:id, 'firstChapter').click

    next_chapter = true
    while next_chapter
      content = wait.until { driver.find_element(:css, '#chapter-c').attribute("innerHTML") }
      chapter = wait.until { driver.find_element(:css, '.chapter-title') }
      name_chapter = chapter.text
      link_chapter = chapter.attribute('href')
      count += 1
      file << [count, name_chapter, link_chapter, content]
      p "#{count} - #{name_chapter} - #{link_chapter}"
      next_chap = wait.until {
        driver.find_element(:id, 'next_chap')
      }
      if next_chap[:class].include?('disabled')
        next_chapter = false
      else
        sleep 2
        next_chap.click
      end
    end
  end
end


list_link_story.each do |link|
  run link
rescue Selenium::WebDriver::Error::TimeoutError => e
  $log.puts("[ERROR][#{Time.now}][#{link}] #{e.message}")
  next
end
