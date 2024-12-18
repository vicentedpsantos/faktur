# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/faktur/models/invoice"

RSpec.describe Faktur::Models::Invoice do
  let(:attributes) do
    {
      id: 1,
      client_id: 123,
      client_name: "Test Client",
      amount: 1000,
      currency: "USD",
      invoice_date: "2023-10-01",
      due_date: "2023-10-15",
      number: "INV-001",
      created_at: Time.now
    }
  end

  let(:client_config) do
    double(
      "ClientConfig",
      client_name: "Test Client",
      due_date: "2023-10-15",
      next_invoice_number: "INV-001",
      id: 123
    )
  end

  describe "#initialize" do
    context "when from_rows is false" do
      it "initializes from input" do
        invoice = described_class.new(attributes, client_config: client_config, from_rows: false)
        expect(invoice.instance_variable_get(:@attributes)).to eq(attributes)
        expect(invoice.instance_variable_get(:@client_config)).to eq(client_config)
      end
    end

    context "when from_rows is true" do
      it "initializes from rows" do
        invoice = described_class.new(attributes.values, from_rows: true)
        Faktur::Models::Invoice::ATTRS.each_with_index do |attr, index|
          expect(invoice.instance_variable_get("@#{attr}")).to eq(attributes.values[index])
        end
      end
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the invoice" do
      invoice = described_class.new(attributes, client_config: client_config, from_rows: false)
      expected_hash = {
        client_name: "Test Client",
        amount: 1000,
        currency: "USD",
        invoice_date: Time.now.strftime("%Y-%m-%d"),
        due_date: "2023-10-15",
        number: "INV-001",
        client_id: 123
      }
      expect(invoice.to_h).to eq(expected_hash)
    end
  end

  describe "#initialize_from_rows" do
    it "sets instance variables from rows" do
      invoice = described_class.new(attributes.values, from_rows: true)
      Faktur::Models::Invoice::ATTRS.each_with_index do |attr, index|
        expect(invoice.instance_variable_get("@#{attr}")).to eq(attributes.values[index])
      end
    end
  end

  describe "#initialize_from_input" do
    it "sets @attributes and @client_config" do
      invoice = described_class.new(attributes, client_config: client_config, from_rows: false)
      expect(invoice.instance_variable_get(:@attributes)).to eq(attributes)
      expect(invoice.instance_variable_get(:@client_config)).to eq(client_config)
    end
  end
end
