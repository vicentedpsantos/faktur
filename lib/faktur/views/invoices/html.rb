# frozen_string_literal: true

require "action_view"

module Faktur
  module Views
    module Invoices
      # HTML class
      class HTML
        include ActionView::Helpers

        def initialize(invoice, client_config)
          @invoice = invoice
          @client_config = client_config
        end

        def render
          <<-HTML
          <!DOCTYPE html>
          <html>
          <head>
            <title>Invoice ##{@invoice.number}</title>
            <style>
              body { font-family: Arial, sans-serif; }
              .invoice-box { max-width: 800px; margin: auto; padding: 30px; border: 1px solid #eee; box-shadow: 0 0 10px rgba(0, 0, 0, 0.15); }
              .invoice-box table { width: 100%; line-height: inherit; text-align: left; }
              .invoice-box table td { padding: 5px; vertical-align: top; }
              .invoice-box table tr td:nth-child(2) { text-align: right; }
              .invoice-box table tr.top table td { padding-bottom: 20px; }
              .invoice-box table tr.top table td.title { font-size: 45px; line-height: 45px; color: #333; }
              .invoice-box table tr.information table td { padding-bottom: 40px; }
              .invoice-box table tr.heading td { background: #eee; border-bottom: 1px solid #ddd; font-weight: bold; }
              .invoice-box table tr.details td { padding-bottom: 20px; }
              .invoice-box table tr.item td { border-bottom: 1px solid #eee; }
              .invoice-box table tr.item.last td { border-bottom: none; }
              .invoice-box table tr.total td:nth-child(2) { border-top: 2px solid #eee; font-weight: bold; }
            </style>
          </head>
          <body>
            <div class="invoice-box">
              <table cellpadding="0" cellspacing="0">
                <tr class="top">
                  <td colspan="2">
                    <table>
                      <tr>
                        <td class="title">
                          <h1>Invoice</h1>
                        </td>
                        <td>
                          Invoice #: #{@invoice.number}<br>
                          Created: #{@invoice.created_at}<br>
                          Due: #{@invoice.due_date}
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr class="information">
                  <td colspan="2">
                    <table>
                      <tr>
                        <td>
                          #{@client_config.client_name}<br>
                          #{@client_config.client_address}<br>
                          VAT: #{@client_config.client_vat}
                        </td>
                        <td>
                          Name: #{@client_config.beneficiary_name}<br>
                          Tax Number: #{@client_config.beneficiary_tax_number}<br>
                          Address: #{@client_config.beneficiary_address}
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr class="heading">
                  <td>Bank Account Information</td>
                  <td></td>
                </tr>
                <tr class="details">
                  <td>Beneficiary Name: #{@client_config.bank_account_beneficiary_name}</td>
                  <td></td>
                </tr>
                <tr class="details">
                  <td>IBAN: #{@client_config.bank_account_iban}</td>
                  <td></td>
                </tr>
                <tr class="details">
                  <td>SWIFT Code: #{@client_config.bank_account_swift}</td>
                  <td></td>
                </tr>
                <tr class="details">
                  <td>Bank Name: #{@client_config.bank_name}</td>
                  <td></td>
                </tr>
                <tr class="details">
                  <td>Address: #{@client_config.bank_account_address}</td>
                  <td></td>
                </tr>
                <tr class="heading">
                  <td>Terms of Payment</td>
                  <td></td>
                </tr>
                <tr class="details">
                  <td>Due date: #{@invoice.due_date}</td>
                  <td></td>
                </tr>
                <tr class="heading">
                  <td>Description</td>
                  <td>Amount</td>
                </tr>
                <tr class="item">
                  <td>#{@client_config.service_description}</td>
                  <td>#{@invoice.currency} #{formatted_amount}</td>
                </tr>
                <tr class="total">
                  <td></td>
                  <td>Total: #{@invoice.currency} #{formatted_amount}</td>
                </tr>
              </table>
            </div>
          </body>
          </html>
          HTML
        end

        def formatted_amount
          number_to_currency(@invoice.amount)
        end
      end
    end
  end
end
