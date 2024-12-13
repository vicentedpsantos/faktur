# frozen_string_literal: true

module SQLQueries
  CREATE_TABLES = <<-SQL
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
end
