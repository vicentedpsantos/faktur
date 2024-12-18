# frozen_string_literal: true

require "spec_helper"
require "faktur/data/invoice"
require "faktur/database"
require "faktur/models/invoice"

RSpec.describe Faktur::Data::Invoice do
  let(:data) { { client_id: 1, amount: 1000, currency: "USD", invoice_date: "2023-10-01", due_date: "2023-10-15" } }
  let(:where) { { client_id: 1 } }
  let(:results) { [data] }

  describe ".create" do
    it "creates an invoice" do
      expect(Faktur::Database).to receive(:create).with("invoices", data).and_yield
      expect { described_class.create(data) }.to output("Invoice created successfully!\n").to_stdout
    end
  end

  describe ".list" do
    it "lists invoices" do
      expect(Faktur::Database).to receive(:list).with("invoices", where).and_yield(results)
      invoices = described_class.list(where)
      expect(invoices.first).to be_a(Faktur::Models::Invoice)
    end
  end

  describe ".find_by" do
    it "finds an invoice by criteria" do
      allow(described_class).to receive(:list).with(where).and_return(results.map { |row|
        Faktur::Models::Invoice.new(row, from_rows: true)
      })
      invoice = described_class.find_by(where)
      expect(invoice).to be_a(Faktur::Models::Invoice)
    end
  end
end
