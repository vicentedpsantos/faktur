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
        yield if block_given?
      rescue SQLite3::ConstraintException => e
        puts "Resource not saved: #{e.message}"
      ensure
        db.close
      end
    end

    def self.list(table_name)
      where = build_where_clause(where)

      process do
        results db.execute("SELECT * FROM #{table_name}#{where}")

        yield results if block_given?
      end
    end

    def self.build_where_clause(where)
      return "" if where.empty?

      where.map { |k, v| "#{k} = '#{v}'" }.join(" AND ").prepend(" WHERE ")
    end

    def self.get_record(db, table_name, id)
      process { db.execute("SELECT * FROM #{table_name} WHERE id = ?", id).first }
    end

    def self.delete(table_name, where)
      setup
      where = build_where_clause(where)
      process { db.execute("DELETE FROM #{table_name}#{where}", id) }
    end

    def self.execute_update(db, table_name, id, data)
      set_clause = data.keys.map { |key| "#{key} = ?" }.join(", ")
      values = data.values << id

      db.execute(
        "UPDATE #{table_name} SET #{set_clause} WHERE id = ?",
        values
      )
    end

    def self.process
      setup
      db = SQLite3::Database.new(DB_PATH)

      begin
        yield
      rescue SQLite3::SQLException => e
        puts "Error: #{e.message}"
      ensure
        db.close
      end
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
