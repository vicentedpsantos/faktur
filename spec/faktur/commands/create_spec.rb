# frozen_string_literal: true

RSpec.describe Faktur::Commands::Create do
  subject(:create_command) { described_class.new }

  let(:config_name) { "test_config" }
  let(:mock_config_data) do
    {
      name: config_name,
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

  before do
    allow(create_command).to receive(:ask) do |prompt|
      key = CONFIGURATION_PROMPTS.key(prompt)
      mock_config_data[key] if key
    end

    allow(Faktur::Database).to receive(:create)
  end

  describe "#configuration" do
    it "prompts the user for each configuration value" do
      CONFIGURATION_PROMPTS.each do |key, prompt|
        expect(create_command).to receive(:ask).with(prompt).and_return(mock_config_data[key])
      end

      create_command.configuration(config_name)
    end

    it "saves the configuration with the correct data" do
      expected_config = mock_config_data

      create_command.configuration(config_name)

      expect(Faktur::Database).to have_received(:create).with(expected_config)
    end
  end
end
