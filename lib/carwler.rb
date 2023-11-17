$LOAD_PATH << File.dirname(__FILE__)

require 'carwler/selenium_driver/selenium_driver'
require 'carwler/output/output'

list_link_story = [
  "https://truyenchu.vn/toan-tri-doc-gia-app",
  "https://truyenchu.vn/do-thi-cuc-pham-y-than",
  "https://truyenchu.vn/nghich-thien-chi-ton"
]

args = {
  stories: {
    story_name: ".story-title a",
    story_description: ".desc-text",
    story_author: ".info div[itemprop='author'] a",
    story_category: ".info a[itemprop='genre']",
    story_status: ".info div:nth-child(4)",
  },
  chapters: {
    chapter_first_chapter: "#firstChapter",
    chapter_next: "#next_chap",
    chapter_title: ".chapter-title",
    chapter_content: "#chapter-c"
  }
}

driver, wait = Carwler::SeleniumDriver::Base.create_driver

list_link_story.each do |link|
  Carwler::SeleniumDriver::CarlwerAutoNextChapter.new(
    link,
    driver,
    wait,
    nil,
    args
  ).run
rescue Selenium::WebDriver::Error::TimeoutError => e
  $log.puts("[ERROR][#{Time.now}][#{link}] #{e.message}")
  next
end
