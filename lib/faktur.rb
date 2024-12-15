# frozen_string_literal: true

require "thor"
require "sqlite3"

require_relative "faktur/version"
require_relative "./faktur/commands/configurations"
require_relative "./faktur/commands/invoices"

module Faktur
  # CLI class
  class CLI < Thor
    register(
      Faktur::Commands::Configurations,
      "configurations",
      "configurations [action]",
      "Type faktur configurations for help."
    )

    register(
      Faktur::Commands::Invoices,
      "invoices",
      "invoices [action]",
      "Type faktur invoices for help."
    )

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
