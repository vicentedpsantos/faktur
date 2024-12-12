# frozen_string_literal: true

require "sqlite3"

module Faktur
  # Database class
  class Database
    DB_PATH = File.expand_path("~/.config/faktur/config.db")

    def self.setup
      db = SQLite3::Database.new(DB_PATH)
      create_config_table(db)
      db.close
    end

    def self.create(config)
      setup

      db = SQLite3::Database.new(DB_PATH)
      insert_config(db, config)
      db.close
    end

    # rubocop:disable Metrics/MethodLength
    def self.create_config_table(db)
      db.execute(
        <<-SQL
          CREATE TABLE IF NOT EXISTS config (
            id INTEGER PRIMARY KEY,
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
            name TEXT,
            payment_terms TEXT,
            service_description TEXT,
            invoice_numbering TEXT
          );
        SQL
      )
    end

    def self.insert_config(db, config)
      db.execute(
        "INSERT INTO config (
          client_name, client_address, client_vat, beneficiary_name,
          beneficiary_tax_number, beneficiary_address, bank_account_beneficiary_name,
          bank_account_address, bank_account_iban, bank_account_swift, bank_name,
          name, payment_terms, service_description, invoice_numbering
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
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
        config[:name],
        config[:payment_terms],
        config[:service_description],
        config[:invoice_numbering]
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
