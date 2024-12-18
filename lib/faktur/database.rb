# frozen_string_literal: true

require "sqlite3"
require_relative "./models/configuration"
require_relative "sql_queries"

module Faktur
  # Database class
  class Database
    DB_DIR = File.expand_path("~/.config/faktur")
    DB_NAME = "faktur.db"

    def self.setup(db_dir = DB_DIR, setup_queries = SQLQueries::CREATE_TABLE_QUERIES)
      FileUtils.mkdir_p(db_dir)
      db = SQLite3::Database.new("#{db_dir}/#{DB_NAME}")
      create_tables(db, setup_queries)

      yield db if block_given?
    end

    def self.create(table_name, data)
      process do |db|
        insert_data(db, table_name, data)

        yield if block_given?
      end
    end

    def self.list(table_name, where = {})
      where = build_where_clause(where)

      process do |db|
        results = db.execute("SELECT * FROM #{table_name}#{where}")

        yield results if block_given?
      end
    end

    def self.build_where_clause(where)
      return "" if where.empty?

      where.map { |k, v| "#{k} = '#{v}'" }.join(" AND ").prepend(" WHERE ")
    end

    def self.get_record(table_name, id)
      process do |db|
        db.execute("SELECT * FROM #{table_name} WHERE id = ?", id).first
      end
    end

    def self.delete(table_name, where)
      where = build_where_clause(where)
      process do |db|
        db.execute("DELETE FROM #{table_name}#{where}")
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

    def self.process
      setup do |db|
        yield db
      rescue SQLite3::SQLException => e
        puts "Error: #{e.message}"
      ensure
        db.close
      end
    end

    def self.create_tables(db, setup_queries)
      setup_queries.each do |query|
        db.execute(query)
      end
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
