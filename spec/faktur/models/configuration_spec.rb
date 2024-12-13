# frozen_string_literal: true

require "spec_helper"

# rubocop:disable Metrics/BlockLength
RSpec.describe Faktur::Models::Configuration do
  subject(:configuration) { described_class }

  let(:attributes_hash) do
    {
      id: 1,
      name: "TestConfig",
      client_name: "Client Co.",
      client_address: "1234 Elm Street",
      client_vat: "123456789",
      beneficiary_name: "Beneficiary Name",
      beneficiary_tax_number: "987654321",
      beneficiary_address: "4321 Oak Avenue",
      bank_account_beneficiary_name: "Bank Beneficiary",
      bank_account_address: "5678 Pine Blvd",
      bank_account_iban: "IBAN1234567890",
      bank_account_swift: "SWIFT12345",
      bank_name: "Big Bank",
      payment_terms: "30d",
      service_description: "Consulting services",
      invoice_numbering: "sequential"
    }
  end

  let(:attributes_row) { attributes_hash.values }

  describe "::ATTRS" do
    it "is defined in the correct order" do
      expected_order = %i[
        id name client_name client_address client_vat beneficiary_name
        beneficiary_tax_number beneficiary_address bank_account_beneficiary_name
        bank_account_address bank_account_iban bank_account_swift bank_name
        payment_terms service_description invoice_numbering
      ]
      expect(described_class::ATTRS).to eq(expected_order)
    end
  end

  describe "#initialize" do
    context "when initialized with a hash" do
      it "assigns the correct attributes" do
        config = described_class.new(attributes_hash)

        attributes_hash.each do |key, value|
          expect(config.send(key)).to eq(value)
        end
      end
    end

    context "when initialized from rows" do
      it "assigns the correct attributes in order" do
        config = described_class.new(attributes_row, from_rows: true)

        described_class::ATTRS.each_with_index do |attr, index|
          expect(config.send(attr)).to eq(attributes_row[index])
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
