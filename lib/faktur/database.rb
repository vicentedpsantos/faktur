# frozen_string_literal: true

require "sqlite3"
require_relative "./models/configuration"

module Faktur
  # Database class
  class Database
    DB_PATH = File.expand_path("~/.config/faktur/faktur.db")

    def self.setup
      db = SQLite3::Database.new(DB_PATH)
      create_config_table(db)
      db.close
    end

    def self.create(config)
      setup

      db = SQLite3::Database.new(DB_PATH)

      begin
        insert_config(db, config)
        puts "Resource saved successfully!"
      rescue SQLite3::ConstraintException => e
        puts "Resource not saved: #{e.message}"
      ensure
        db.close
      end
    end

    def self.list(table_name, model)
      setup

      db = SQLite3::Database.new(DB_PATH)
      results = db.execute("SELECT * FROM #{table_name}")

      results.map { |row| model.new(row, from_rows: true) }
    end

    # rubocop:disable Metrics/MethodLength
    def self.create_config_table(db)
      db.execute(
        <<-SQL
          CREATE TABLE IF NOT EXISTS configs (
            id INTEGER PRIMARY KEY,
            name TEXT UNIQUE,
            client_name TEXT,
            client_address TEXT,
            client_vat TEXT,
            beneficiary_name TEXT,
            beneficiary_tax_number TEXT,
            beneficiary_address TEXT,
            bank_account_beneficiary_name TEXT,
            bank_account_address TEXT,
            bank_account_iban TEXT,
            bank_account_swift TEXT,
            bank_name TEXT,
            payment_terms TEXT,
            service_description TEXT,
            invoice_numbering TEXT
          );
        SQL
      )
    end

    def self.insert_config(db, config)
      db.execute(
        "INSERT INTO configs (
          name, client_name, client_address, client_vat, beneficiary_name,
          beneficiary_tax_number, beneficiary_address, bank_account_beneficiary_name,
          bank_account_address, bank_account_iban, bank_account_swift, bank_name,
          payment_terms, service_description, invoice_numbering
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        config[:name],
        config[:client_name],
        config[:client_address],
        config[:client_vat],
        config[:beneficiary_name],
        config[:beneficiary_tax_number],
        config[:beneficiary_address],
        config[:bank_account_beneficiary_name],
        config[:bank_account_address],
        config[:bank_account_iban],
        config[:bank_account_swift],
        config[:bank_name],
        config[:payment_terms],
        config[:service_description],
        config[:invoice_numbering]
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
