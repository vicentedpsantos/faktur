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

        Faktur::Database.create(TABLE_NAME, invoice.to_h)
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

      desc "print", "Print an invoice"
      def print(id)
        invoice = Faktur::Data::Invoice.find_by({ id: id })
        client_config = Faktur::Data::Configuration({ id: invoice.client_id })

        pdf = Faktur::Views::Invoices::PDF.new(invoice, client_config)
        pdf_file = pdf.render

        File.open("invoice.pdf", "wb") do |file|
          file.write(pdf_file)
        end
      end
    end
  end
end
