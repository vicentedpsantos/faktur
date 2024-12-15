# frozen_string_literal: true

module Faktur
  module Models
    # Configuration class
    class Invoice
      def initialize(attributes, client_config, from_rows: false)
        @attributes = attributes
        @client_config = client_config
      end

      def to_h
        {
          client_name: @client_config.client_name,
          amount: @attributes[:amount],
          currency: @attributes[:currency],
          invoice_date: Time.now.strftime("%Y-%m-%d"),
          due_date: @client_config.due_date,
          invoice_number: @client_config.next_invoice_number,
          client_id: @client_config.id
        }
      end

    end
  end
end
