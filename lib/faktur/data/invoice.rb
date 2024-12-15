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
        Faktur::Database.setup

        db = SQLite3::Database.new(Faktur::Database::DB_PATH)

        begin
          insert_data(db, TABLE_NAME, data)
          puts "Resource saved successfully!"
        rescue SQLite3::ConstraintException => e
          puts "Resource not saved: #{e.message}"
        ensure
          db.close
        end
      end

      def self.list(where = {})
        Faktur::Database.setup

        db = SQLite3::Database.new(Faktur::Database::DB_PATH)

        where = build_where_clause(where)
        results = db.execute("SELECT * FROM #{TABLE_NAME}#{where}")

        results.map { |row| Faktur::Models::Invoice.new(row, from_rows: true) }
      end

      def self.build_where_clause(where)
        return "" if where.empty?

        where.map { |k, v| "#{k} = '#{v}'" }.join(" AND ").prepend(" WHERE ")
      end
    end
  end
end
