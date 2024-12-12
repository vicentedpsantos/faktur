# frozen_string_literal: true

require "thor"
require_relative "../database"

module Faktur
  module Commands
    # List resources class
    class List < Thor
      desc "configurations", "List all invoice configurations"

      def configurations
        configs = list("configs", Faktur::Models::Configuration)

        puts "Listing all invoice configurations by name..."
        configs.each do |config|
          puts "#{config.id}. #{config.name}"
        end
      end

      private

      def list(table_name, model)
        Faktur::Database.list(table_name, model)
      end
    end
  end
end
