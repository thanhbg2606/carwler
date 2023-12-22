module Crawler

  module NokogiriDriver

    class CrawlContent
      require 'net/http'

      attr_accessor :response, :params, :result

      def initialize response, params
        @params = params
        @result = Hash.new
        @response = Nokogiri::HTML(response)
      end

      def run
        analysis_content
      end

      private

      def analysis_content
        # 1. Nếu key chứa /array/ thì return array, còn lại return string
        # 2. Nếu action empty thì return với action innerText
        # 3. Nếu action nằm trong white list action(atributes) sẽ sử dụng action đó để trả về
        # 4. Nếu action không nằm trong white list thì sẽ hiểu là return value của attribute action
        # 5. Nếu không tìm được giá trị thì sẽ return null

        params.each do |key, arr_value|
          # arr_value[0]: location
          # arr_value[1]: action

          # if key include array -> return array
          if key.include?("array")
            result[key] = response.css(arr_value[0]).map{ |item| get_value(item, arr_value[1]) }
          else
            element = response.at_css(arr_value[0])
            result[key] = get_value(element, arr_value[1])
          end
        end
        result
      end

      def get_value element, action
        convert = {
          "innerHTML" => "inner_html",
          "innerText" => "inner_text",
        }

        # if action empty -> get default text action
        return element.text.strip if action.empty?

        if convert.has_key?(action)
          action_method = convert[action]
          return element.send(action_method).strip
        end

        return element[action]
      rescue StandardError => e
        Rails.logger.error(e)
        nil
      end
    end

  end

end
