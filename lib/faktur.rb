# frozen_string_literal: true

require "thor"
require "sqlite3"

require_relative "faktur/version"

module Faktur
  class CLI < Thor
    def configure
      puts "Running configure command..."
    end

    desc "new AMOUNT CURRENCY", "Create a new invoice"
    def new(amount, currency)
      puts "Running new command..."
      puts "Amount: #{amount}"
      puts "Currency: #{currency}"
    end

    desc "list", "List all invoices"
    def list
      puts "Listing all invoices..."
    end
  end
end
