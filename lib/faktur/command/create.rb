# frozen_string_literal: true

require "thor"
require_relative "../database"

CONFIGURATION_PROMPTS = {
  client_name: "Enter the default client name: ",
  client_address: "Enter the default client address: ",
  client_vat: "Enter the default client VAT (optional): ",
  beneficiary_name: "Enter the default beneficiary name: ",
  beneficiary_tax_number: "Enter the default beneficiary tax registration number: ",
  beneficiary_address: "Enter the default beneficiary address: ",
  bank_account_beneficiary_name: "Enter the default bank account beneficiary name: ",
  bank_account_address: "Enter the default bank account address: ",
  bank_account_iban: "Enter the default bank account IBAN: ",
  bank_account_swift: "Enter the default bank account SWIFT code: ",
  bank_name: "Enter the default bank name: ",
  payment_terms: "Enter the default terms of payment (Choose between: 10d, 20d, 30d, eof (end of month)): ",
  service_description: "Enter the default description of services provided: ",
  invoice_numbering: "Choose the default invoice numbering system (sequential or random): "
}.freeze

module Faktur
  module Command
    # Create resources class
    class Create < Thor
      desc "configuration NAME", "Create a new invoice configuration"
      def configuration(name)
        puts "Setting up your invoice configuration..."

        config = { name: name }

        CONFIGURATION_PROMPTS.each { |key, prompt| config[key] = ask(prompt) }

        save_configuration(config)

        puts "Configuration saved successfully!"
      end

      private

      def save_configuration(config)
        Faktur::Database.create(config)
      end
    end
  end
end
