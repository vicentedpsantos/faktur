# frozen_string_literal: true

require "sqlite3"
require_relative "../models/configuration"
require_relative "../database"

module Faktur
  module Data
    # Configuration data class
    class Configuration
      TABLE_NAME = "configs"

      def self.create(data)
        Faktur::Database.setup

        Faktur::Database.create(TABLE_NAME, data) do
          puts "Configuration saved successfully"
        end
      end

      def self.list(where = {})
        Faktur::Database.list(TABLE_NAME, where) do |results|
          results.map { |row| Faktur::Models::Configuration.new(row, from_rows: true) }
        end
      end

      def self.find_by(where = {})
        list(where).first
      end

      def self.delete(where = {})
        Faktur::Database.delete(where)
      end

      def self.execute_update(db, table_name, id, data)
        set_clause = data.keys.map { |key| "#{key} = ?" }.join(", ")
        values = data.values << id

        db.execute(
          "UPDATE #{table_name} SET #{set_clause} WHERE id = ?",
          values
        )
      end
    end
  end
end
