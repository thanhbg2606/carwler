require "logger"
require "pry"

module Carwler

  module SeleniumDriver

    class CarlwerAutoNextChapter
      attr_reader :link, :driver, :wait, :output, :stories, :chapters, :logger

      def initialize link, driver, wait, output, args
        @link = link
        @driver = driver
        @wait = wait
        @output = output
        @stories = args[:stories] || (raise ArgumentError, "must pass argument stories")
        @chapters = args[:chapters] || (raise ArgumentError, "must pass argument chapters")

        logger = Logger.new('../../../carwler.log', 'weekly')
      end

      def run
        carwler_index_story
        carwler_chapters
      end

      # story_name -> .story-title a -> text
      # story_description -> .desc-text -> text
      # story_author -> .info div[itemprop='author'] a
      # story_category -> .info a[itemprop='genre']
      # story_source ->
      # story_status -> .info div:nth-child(4)
      # story_first_chapter -> #firstChapter

      # chapter_next -> #next_chap
      # chapter_title -> .chapter-title
      # chapter_content -> #chapter-c
      # chapter_url ->
      def carwler_index_story
        data = {}

        driver.navigate.to link
        stories.each do |key, value|
          data[key] = wait.until { driver.find_element(:css, value).text }
        end
      end

      def carwler_chapters
        count = 0
        navigate_first_chapter = driver.find_element(:css, chapters[:chapter_first_chapter]).click

        next_chapter = true
        while next_chapter
          content = wait.until { driver.find_element(:css, chapters[:chapter_content]).attribute("innerHTML") }
          chapter = wait.until { driver.find_element(:css, chapters[:chapter_title]) }
          name_chapter = chapter.text
          link_chapter = chapter.attribute('href')
          count += 1
          # output.write [count, name_chapter, link_chapter, content]
          p "#{count} - #{name_chapter} - #{link_chapter}"
          next_chap = wait.until {
            driver.find_element(:css, chapters[:chapter_next])
          }
          if next_chap[:class].include?('disabled')
            next_chapter = false
          else
            sleep 2
            next_chapter = false if count == 5
            next_chap.click
          end
        end
      end
    end

  end

end
