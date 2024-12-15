# frozen_string_literal: true

require "thor"
require_relative "../database"
require_relative "../models/invoice"
require_relative "../models/configuration"

INVOICE_PROMPTS = {
  client_name: "Enter the client name: ",
  amount: "Enter the amount: ",
  currency: "Enter the currency (e.g. USD): "
}.freeze

module Faktur
  module Commands
    # Invoices commands class
    class Invoices < Thor
      TABLE_NAME = "invoices"

      desc "create", "Create a new invoice"
      def create
        input = {}
        INVOICE_PROMPTS.each { |key, prompt| input[key] = ask(prompt) }
        client_config = Faktur::Data::Configuration.find_by({ name: input[:client_name] })
        invoice = Faktur::Models::Invoice.new(input, client_config: client_config)

        save_invoice(invoice)
      end

      desc "list", "List all invoices"
      def list
        invoices = Faktur::Data::Invoice.list

        invoices.each do |invoice|
          puts <<-TEXT
            ID #{invoice.id} · \
            #{invoice.client_name} · \
            #{invoice.amount} · #{invoice.currency} · \
            #{invoice.created_at}"
          TEXT
        end
      end

      private

      def get_configuration(input)
        Faktur::Database.find_by(
          "configs",
          { name: input[:client_name] },
          ->(row) { Faktur::Models::Configuration.new(row, from_rows: true) }
        )
      end

      def save_invoice(invoice)
        Faktur::Database.create(TABLE_NAME, invoice.to_h)
      end
    end
  end
end
