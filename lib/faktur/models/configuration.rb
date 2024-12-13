# frozen_string_literal: true

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

      private

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
