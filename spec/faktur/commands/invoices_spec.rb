# frozen_string_literal: true

require "thor"
require "faktur/commands/invoices"
require "faktur/data/invoice"
require "faktur/data/configuration"
require "faktur/models/invoice"
require "faktur/database"
require "faktur/views/invoices/pdf"

RSpec.describe Faktur::Commands::Invoices do
  let(:invoices) { described_class.new }

  describe "#create" do
    let(:input) do
      {
        client_name: "Client Name",
        amount: "1000",
        currency: "USD"
      }
    end
    let(:client_config) { double("ClientConfig") }
    let(:invoice) { double("Invoice", to_h: { client_name: "Client Name", amount: "1000", currency: "USD" }) }

    before do
      allow(invoices).to receive(:ask).and_return(*input.values)
      allow(Faktur::Data::Configuration).to receive(:find_by).with( { name: input[:client_name] }).and_return(client_config)
      allow(Faktur::Models::Invoice).to receive(:new).with(input, client_config: client_config).and_return(invoice)
      allow(Faktur::Database).to receive(:create).with("invoices", invoice.to_h)
    end

    it "creates a new invoice" do
      invoices.create
      expect(Faktur::Database).to have_received(:create).with("invoices", invoice.to_h)
    end
  end

  describe "#list" do
    let(:invoice_list) do
      [double("Invoice", id: 1, client_name: "Client 1", amount: "1000", currency: "USD", created_at: "2023-01-01")]
    end

    before do
      allow(Faktur::Data::Invoice).to receive(:list).and_return(invoice_list)
      allow(invoices).to receive(:puts)
    end

    it "lists all invoices" do
      invoices.list
      invoice_list.each do |invoice|
        expect(invoices).to have_received(:puts).with(/ID/)
      end
    end
  end

  describe "#list when there are no invoices" do
    before do
      allow(Faktur::Data::Invoice).to receive(:list).and_return([])
      allow(invoices).to receive(:puts)
    end

    it "lists all invoices" do
      invoices.list
      expect(invoices).to have_received(:puts).with("No invoices found")
    end
  end

  describe "#print" do
    let(:id) { 1 }
    let(:invoice) { double("Invoice", id: id, client_id: 1) }
    let(:client_config) { double("ClientConfig") }
    let(:pdf) { double("PDF", render: "pdf_content") }

    before do
      allow(Faktur::Data::Invoice).to receive(:find_by).with({ id: id }).and_return(invoice)
      allow(Faktur::Data::Configuration).to receive(:find_by).with({ id: invoice.client_id }).and_return(client_config)
      allow(Faktur::Views::Invoices::PDF).to receive(:new).with(invoice, client_config).and_return(pdf)
      allow(File).to receive(:open).with("invoice.pdf", "wb")
    end

    it "prints an invoice" do
      invoices.print(id)
      expect(File).to have_received(:open).with("invoice.pdf", "wb")
    end
  end
end
