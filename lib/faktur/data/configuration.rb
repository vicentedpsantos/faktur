# frozen_string_literal: true

require "sqlite3"
require_relative "../models/configuration"
require_relative "../database"

module Faktur
  module Data
    # Configuration data class
    class Configuration
      TABLE_NAME = "configurations"

      def self.create(data)
        Faktur::Database.setup

        db = SQLite3::Database.new(Faktur::Database::DB_PATH)

        begin
          insert_data(db, TABLE_NAME, data)
          puts "Configuration saved successfully!"
        rescue SQLite3::ConstraintException => e
          puts "Configuration not saved: #{e.message}"
        ensure
          db.close
        end
      end

      def self.list(where = {})
        Faktur::Database.setup
        db = SQLite3::Database.new(Faktur::Database::DB_PATH)

        where = build_where_clause(where)
        results = db.execute("SELECT * FROM #{TABLE_NAME}#{where}")

        results.map { |row| Faktur::Models::Configuration.new(row, from_rows: true) }
      end

      def self_find_by(where = {})
        list(where).first
      end

      def self.delete(where = {})
        Faktur::Database.setup
        db = SQLite3::Database.new(Faktur::Database::DB_PATH)

        where = build_where_clause(where)
        db.execute("DELETE FROM #{TABLE_NAME}#{where}")
        puts "Configuration deleted successfully!"
      rescue SQLite3::SQLException => e
        puts "Record could not be deleted: #{e.message}"
      end

      def self.update(table_name, id, data)
        setup
        db = SQLite3::Database.new(DB_PATH)

        begin
          execute_update(db, table_name, id, data)
          updated_record = get_record(db, table_name, id)
          puts "Resource updated successfully!"
          updated_record
        rescue SQLite3::ConstraintException => e
          puts "Resource not updated: #{e.message}"
        ensure
          db.close
        end
      end

      def self.execute_update(db, table_name, id, data)
        set_clause = data.keys.map { |key| "#{key} = ?" }.join(", ")
        values = data.values << id

        db.execute(
          "UPDATE #{table_name} SET #{set_clause} WHERE id = ?",
          values
        )
      end

      def self.build_where_clause(where)
        return "" if where.empty?

        where.map { |k, v| "#{k} = '#{v}'" }.join(" AND ").prepend(" WHERE ")
      end
    end
  end
end
