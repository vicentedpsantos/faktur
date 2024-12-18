# frozen_string_literal: true

module Faktur
  module Models
    # Configuration class
    class Invoice
      ATTRS = %i[
        id client_id client_name amount currency
        invoice_date due_date number created_at
      ].freeze

      attr_reader(*ATTRS)

      def initialize(attributes, client_config: nil, from_rows: false, options: {})
        @options = options

        from_rows ? initialize_from_rows(attributes) : initialize_from_input(attributes, client_config)
      end

      def to_h
        {
          client_name: @client_config.client_name,
          amount: @attributes[:amount],
          currency: @attributes[:currency],
          invoice_date: Time.now.strftime("%Y-%m-%d"),
          due_date: @client_config.due_date,
          number: @options[:number] || @client_config.next_invoice_number,
          client_id: @client_config.id
        }
      end

      private

      def initialize_from_rows(attributes)
        attributes[7] = override_number(attributes)

        ATTRS.each_with_index do |attr, index|
          instance_variable_set("@#{attr}", attributes[index])
        end
      end

      def initialize_from_input(attributes, client_config)
        attributes[7] = override_number(attributes)

        @attributes = attributes
        @client_config = client_config
      end

      private

      def override_number(attributes)
        @options[:number] || attributes[7]
      end
    end
  end
end
