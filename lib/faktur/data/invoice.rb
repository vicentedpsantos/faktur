# frozen_string_literal: true

require "sqlite3"
require_relative "../models/invoice"
require_relative "../database"

module Faktur
  module Data
    # Invoice data class
    class Invoice
      TABLE_NAME = "invoices"

      def self.create(data)
        Faktur::Database.create(TABLE_NAME, data) do
          puts "Invoice created successfully!"
        end
      end

      def self.list(where = {})
        Faktur::Database.list(TABLE_NAME, where) do |results|
          results.map { |row| Faktur::Models::Invoice.new(row, from_rows: true) }
        end
      end
    end
  end
end
