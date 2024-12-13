# frozen_string_literal: true

require "sqlite3"
require_relative "./models/configuration"
require_relative "sql_queries"

module Faktur
  # Database class
  class Database
    DB_PATH = File.expand_path("~/.config/faktur/faktur.db")

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
