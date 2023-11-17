require 'csv'

module Carwler
  module Output
    class Csv
      attr_reader :csv

      def initialize filename
        @csv = CSV.open("#{file_name}.csv", 'w')
      end

      # def << content
      #   csv << content
      # end

      def write content
        csv << content
      end

      def read file
        csv.read
      end
    end
  end
end
