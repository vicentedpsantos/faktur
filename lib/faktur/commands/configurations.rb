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

TABLE_NAME = "configs"

module Faktur
  module Commands
    # Configurations commands class
    class Configurations < Thor
      desc "create NAME", "Create a new invoice configuration"
      def create(name)
        config = { name: name }

        CONFIGURATION_PROMPTS.each { |key, prompt| config[key] = ask(prompt) }

        save_configuration(config)
      end

      desc "list", "List all configurations"
      def list
        configs = list_configurations(
          ->(row) { Faktur::Models::Configuration.new(row, from_rows: true) }
        )

        configs.each { |config| puts "ID #{config.id} · #{config.name}" }
      end

      desc "show NAME", "Show a configuration"
      def show(name)
        config = get_configuration(name, ->(row) { Faktur::Models::Configuration.new(row, from_rows: true) })

        Faktur::Models::Configuration::ATTRS.each do |attr|
          puts "#{attr.to_s.split("_").map(&:capitalize).join(" ")}: #{config.send(attr)}"
        end
      end

      desc "delete ID", "Delete a configuration"
      def delete(id)
        delete_configuration(id)

        puts "Configuration deleted successfully!"
      end

      private

      def delete_configuration(id)
        Faktur::Database.delete(TABLE_NAME, id)
      end


      def get_configuration(name, build_fn)
        config = Faktur::Database.find_by(TABLE_NAME, { name: name }, build_fn)
      end

      def list_configurations(build_fn)
        Faktur::Database.list(TABLE_NAME, build_fn)
      end

      def save_configuration(config)
        Faktur::Database.create(TABLE_NAME, config)
      end
    end
  end
end
