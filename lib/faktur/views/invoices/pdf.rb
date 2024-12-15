require "prawn"

module Faktur
  module Views
    module Invoices
      # PDF class
      class PDF
        def initialize(invoice, client_config)
          @invoice = invoice
          @client_config = client_config
        end

        def render
          Prawn::Document.new do |pdf|
            pdf.text "Invoice ##{@invoice.number}", size: 30, style: :bold
            pdf.move_down 20

            pdf.text "Client Information:", size: 20, style: :bold
            pdf.text "Name: #{@client_config.client_name}"
            pdf.text "Address: #{@client_config.client_address}"
            pdf.move_down 20

            pdf.text "Invoice Details:", size: 20, style: :bold
            pdf.text "Date: #{@invoice.created_at}"
            pdf.text "Total: #{@invoice.amount}"
            pdf.move_down 20

            pdf.text "Description: #{@client_config.service_description}, Price: #{@invoice.currency} #{@invoice.amount}"
          end.render
        end
      end
    end
  end
end
