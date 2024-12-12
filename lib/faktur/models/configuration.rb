# frozen_string_literal: true

module Faktur
  module Models
    # Configuration class
    class Configuration
      attr_reader :name, :client_name, :client_address, :client_vat, :beneficiary_name,
                  :beneficiary_tax_number, :beneficiary_address, :bank_account_beneficiary_name,
                  :bank_account_address, :bank_account_iban, :bank_account_swift, :bank_name,
                  :payment_terms, :service_description, :invoice_numbering

      ATTRS = %i[
        name client_name client_address client_vat beneficiary_name beneficiary_tax_number
        beneficiary_address bank_account_beneficiary_name bank_account_address bank_account_iban
        bank_account_swift bank_name payment_terms service_description invoice_numbering
      ].freeze

      def initialize(attributes, from_rows: false)
        if from_rows
          initialize_from_rows(attributes)
        else
          ATTRS.each { |attr| instance_variable_set("@#{attr}", attributes[attr]) }
        end
      end

      private

      def initialize_from_rows(rows)
        ATTRS.each_with_index do |attr, index|
          # We add 1 to the index because the first row is the id
          instance_variable_set("@#{attr}", rows[index + 1])
        end
      end
    end
  end
end
