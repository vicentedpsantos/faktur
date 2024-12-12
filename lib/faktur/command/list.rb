# frozen_string_literal: true

require "thor"
require_relative "../database"

module Faktur
  module Command
    # List resources class
    class List < Thor
      desc "configurations", "List all invoice configurations"

      def configurations
        configs = list("configs")

        puts configs.inspect
        # puts "Listing all invoice configurations by name..."
        # configs.each do |config|
        #   puts "- #{config["name"]}"
        # end
      end

      private

      def list(table_name)
        Faktur::Database.list(table_name)
      end
    end
  end
end
