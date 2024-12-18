# frozen_string_literal: true

require "prawn"
require "prawn/table"

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
            pdf.font "Helvetica"

            # Header
            pdf.text "Invoice ##{@invoice.number}", size: 30, style: :bold, align: :center
            pdf.move_down 20

            # Client Information
            pdf.text "Client Information", size: 20, style: :bold
            pdf.stroke_horizontal_rule
            pdf.move_down 10
            pdf.text @client_config.client_name.to_s, size: 12
            pdf.text @client_config.client_address.to_s, size: 12
            pdf.text "VAT: #{@client_config.client_vat}", size: 12

            pdf.move_down 20

            # Beneficiary Information
            pdf.text "Beneficiary Information", size: 20, style: :bold
            pdf.stroke_horizontal_rule
            pdf.move_down 10
            pdf.text "Name: #{@client_config.beneficiary_name}", size: 12
            pdf.text "Tax Number: #{@client_config.beneficiary_tax_number}", size: 12
            pdf.text "Address: #{@client_config.beneficiary_address}", size: 12

            pdf.move_down 20

            # Bank Account Information
            pdf.text "Bank Account Information", size: 20, style: :bold
            pdf.stroke_horizontal_rule
            pdf.move_down 10
            pdf.text "Beneficiary Name: #{@client_config.bank_account_beneficiary_name}", size: 12
            pdf.text "IBAN: #{@client_config.bank_account_iban}", size: 12
            pdf.text "SWIFT Code: #{@client_config.bank_account_swift}", size: 12
            pdf.text "Bank Name: #{@client_config.bank_name}", size: 12
            pdf.text "Address: #{@client_config.bank_account_address}", size: 12

            pdf.move_down 20

            # Terms of payment
            pdf.text "Terms of Payment", size: 20, style: :bold
            pdf.stroke_horizontal_rule
            pdf.move_down 10
            pdf.text "Due date: #{@invoice.due_date}", size: 12

            pdf.move_down 20

            # Description Table
            pdf.text "Description", size: 20, style: :bold
            pdf.stroke_horizontal_rule
            pdf.move_down 10
            data = [["Service Description", "Amount"]] +
                   [[@client_config.service_description, "#{@invoice.currency} #{@invoice.amount}"]]
            pdf.table(data, header: true, row_colors: %w[F0F0F0 FFFFFF], width: pdf.bounds.width) do
              row(0).font_style = :bold
              columns(1).align = :right
            end

            pdf.move_down 20

            # Invoice Details
            pdf.text "Invoice Details", size: 20, style: :bold
            pdf.stroke_horizontal_rule
            pdf.move_down 10
            pdf.text "Issued at: #{@invoice.created_at}", size: 12
            pdf.text "Total: #{@invoice.currency} #{@invoice.amount}", size: 12
            pdf.move_down 20
          end.render
        end
      end
    end
  end
end
