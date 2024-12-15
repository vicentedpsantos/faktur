# frozen_string_literal: true

require "sqlite3"
require_relative "./models/configuration"
require_relative "sql_queries"

module Faktur
  # Database class
  class Database
    DB_DIR = File.expand_path("~/.config/faktur")
    DB_PATH = "#{DB_DIR}/faktur.db".freeze

    def self.setup
      db = SQLite3::Database.new(DB_PATH)
      create_tables(db)
      db.close
    end

    def self.create(table_name, data)
      setup

      db = SQLite3::Database.new(DB_PATH)

      begin
        insert_data(db, table_name, data)
        puts "Resource saved successfully!"
      rescue SQLite3::ConstraintException => e
        puts "Resource not saved: #{e.message}"
      ensure
        db.close
      end
    end

    def self.list(table_name, build_fn = ->(x) { x })
      setup

      db = SQLite3::Database.new(DB_PATH)
      results = db.execute("SELECT * FROM #{table_name}")

      results.map { |row| build_fn.call(row) }
    end

    # Rubocop: disable Metrics/MethodLength
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
    # Rubocop: enable Metrics/MethodLength

    def self.get_record(db, table_name, id)
      db.execute("SELECT * FROM #{table_name} WHERE id = ?", id).first
    end

    def self.find_by(table_name, find_by, build_fn = ->(x) { x })
      setup

      db = SQLite3::Database.new(DB_PATH)
      result = db.execute("SELECT * FROM #{table_name} WHERE #{find_by.keys.first} = ?", find_by.values.first).first
      build_fn.call(result)
    end

    def self.delete(table_name, id)
      db = SQLite3::Database.new(DB_PATH)
      db.execute("DELETE FROM #{table_name} WHERE id = ?", id)
      db.close
    rescue SQLite3::SQLException => e
      puts "Record could not be deleted: #{e.message}"
    end

    def self.execute_update(db, table_name, id, data)
      set_clause = data.keys.map { |key| "#{key} = ?" }.join(", ")
      values = data.values << id

      db.execute(
        "UPDATE #{table_name} SET #{set_clause} WHERE id = ?",
        values
      )
    end

    def self.create_tables(db)
      db.execute(SQLQueries::CREATE_TABLES)
    end

    def self.insert_data(db, table_name, data)
      columns = data.keys.join(", ")
      placeholders = (["?"] * data.keys.size).join(", ")
      values = data.values

      db.execute(
        "INSERT INTO #{table_name} (#{columns}) VALUES (#{placeholders})",
        values
      )
    end
  end
end
