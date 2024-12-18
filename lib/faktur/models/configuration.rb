# frozen_string_literal: true

require_relative "../data/invoice"

module Faktur
  module Models
    # Configuration class
    class Configuration
      # Order matters because it's used to initialize the object from rows.
      ATTRS = %i[
        id name client_name client_address client_vat beneficiary_name
        beneficiary_tax_number beneficiary_address bank_account_beneficiary_name
        bank_account_address bank_account_iban bank_account_swift bank_name
        payment_terms service_description invoice_numbering
      ].freeze

      attr_reader(*ATTRS)

      def initialize(attributes, from_rows: false)
        from_rows ? initialize_from_rows(attributes) : initialize_from_attributes(attributes)
      end

      def due_date
        (Time.now + payment_term_days * 24 * 60 * 60).strftime("%d %b, %Y")
      end

      def next_invoice_number
        case invoice_numbering
        when "random"
          generate_random_invoice_number
        when "sequential"
          generate_sequential_invoice_number
        else
          raise "Unknown invoice numbering type: #{invoice_numbering}"
        end
      end

      private

      def generate_random_invoice_number
        (0...8).map { rand(65..90).chr }.join
      end

      def generate_sequential_invoice_number
        last_invoice_number = fetch_last_invoice_number_for_client(id)
        (last_invoice_number.to_i + 1).to_s
      end

      def fetch_last_invoice_number_for_client(client_id)
        Faktur::Data::Invoice.list({ client_id: client_id }).last.number
      rescue StandardError
        "0"
      end

      def payment_term_days
        case payment_terms
        when "10d" then 10
        when "20d" then 20
        when "30d" then 30
        when "eof" then (Date.civil(Date.today.year, Date.today.month, -1) - Date.today).to_i
        else 0
        end
      end

      def initialize_from_attributes(attributes)
        ATTRS.each { |attr| instance_variable_set("@#{attr}", attributes[attr]) }
      end

      def initialize_from_rows(rows)
        ATTRS.each_with_index do |attr, index|
          instance_variable_set("@#{attr}", rows[index])
        end
      end
    end
  end
end
