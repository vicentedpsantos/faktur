# frozen_string_literal: true

require "thor"
require_relative "../database"
require_relative "../models/invoice"
require_relative "../models/configuration"
require_relative "../views/invoice"

INVOICE_PROMPTS = {
  client_name: "Enter the client name: ",
  amount: "Enter the amount: ",
  currency: "Enter the currency (e.g. USD): "
}.freeze

module Faktur
  module Commands
    # Invoices commands class
    class Invoices < Thor
      desc "create", "Create a new invoice"
      option :number, type: :numeric, required: false, desc: "Invoice number"
      def create
        input = {}
        INVOICE_PROMPTS.each { |key, prompt| input[key] = ask(prompt) }
        client_config = Faktur::Data::Configuration.find_by({ name: input[:client_name] })
        invoice = Faktur::Models::Invoice.new(input, client_config: client_config, options: options)

        Faktur::Data::Invoice.create(invoice.to_h)
      end

      desc "list", "List all invoices"
      def list
        invoices = Faktur::Data::Invoice.list

        if invoices.empty?
          puts "No invoices found"
          return
        end

        invoices.each do |invoice|
          puts "ID #{invoice.id} · ##{invoice.number} · #{invoice.client_name} · #{invoice.amount} #{invoice.currency} · #{invoice.created_at}"
        end
      end

      desc "print", "Print an invoice"
      option :format, type: :string, required: false, desc: "Output format (html, pdf)"
      def print(id)
        invoice = Faktur::Data::Invoice.find_by({ id: id })
        client_config = Faktur::Data::Configuration.find_by({ id: invoice.client_id })
        result = Faktur::Views::Invoice.new(invoice, client_config, options).process

        puts "Invoice saved to #{result.path} as #{result.filename}"
      end

      desc "delete", "Delete an invoice"
      def delete(id)
        Faktur::Data::Invoice.delete({ id: id })
      end
    end
  end
end
