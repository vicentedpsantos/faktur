# frozen_string_literal: true

require "thor"
require "sqlite3"

require_relative "faktur/version"
require_relative "./faktur/commands/create"
require_relative "./faktur/commands/list"

module Faktur
  # CLI class
  class CLI < Thor
    register(Faktur::Commands::Create, "create", "create [resource]", "Type faktur create for help")
    register(Faktur::Commands::List, "list", "list [resource]", "Type faktur list for help")

    # desc "new AMOUNT CURRENCY", "Create a new invoice"
    # def new(amount, currency)
    #   puts "Running new command..."
    #   puts "Amount: #{amount}"
    #   puts "Currency: #{currency}"
    # end
    #
    # desc "list", "List all invoices"
    # def list
    #   puts "Listing all invoices..."
    # end
  end
end
