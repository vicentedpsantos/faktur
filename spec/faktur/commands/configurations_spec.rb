# frozen_string_literal: true

require "spec_helper"

RSpec.describe Faktur::Commands::Configurations do
  subject(:configuration_commands) { described_class.new }

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
    allow(configuration_commands).to receive(:ask) do |prompt|
      key = CONFIGURATION_PROMPTS.key(prompt)
      mock_config_data[key] if key
    end

    allow(Faktur::Database).to receive(:create)
    allow(Faktur::Database).to receive(:delete)
    allow(Faktur::Database).to receive(:get_record).and_return(mock_config_data.values)
  end

  describe "#create" do
    it "prompts the user for each configuration value" do
      CONFIGURATION_PROMPTS.each do |key, prompt|
        expect(configuration_commands)
          .to receive(:ask)
          .with(prompt)
          .and_return(mock_config_data[key])
      end

      configuration_commands.create(config_name)
    end

    it "saves the configuration with the correct data" do
      expected_config = mock_config_data

      configuration_commands.create(config_name)

      expect(Faktur::Database).to have_received(:create).with("configs", expected_config)
    end
  end

  describe "#list" do
    let(:mock_config) { double("Configuration", id: 1, name: config_name) }

    before do
      allow(Faktur::Database).to receive(:list).and_return([mock_config])
    end

    it "lists all configurations" do
      expect { configuration_commands.list }
        .to output("ID 1 · #{config_name}\n")
        .to_stdout
    end

    it "does not prompt the user for any input" do
      expect(configuration_commands).not_to receive(:ask)

      configuration_commands.list
    end
  end

  describe "#delete" do
    let(:config_id) { 1 }

    before do
      allow(Faktur::Database).to receive(:delete).with("configs", config_id)
    end

    it "deletes the configuration by its ID" do
      configuration_commands.delete(config_id)
      expect(Faktur::Database).to have_received(:delete).with("configs", config_id)
    end

    it "outputs a success message" do
      expect { configuration_commands.delete(config_id) }
        .to output(/Configuration deleted successfully!/)
        .to_stdout
    end
  end

  describe "#show" do
    let(:config_name) { "test_config" }

    context "when configuration exists" do
      before do
        allow(Faktur::Database)
          .to receive(:find_by)
          .with(
            "configs",
            { name: "test_config" },
            ->(row) { Faktur::Models::Configuration.new(row, from_rows: true) }
          ).and_return(Faktur::Models::Configuration.new(mock_config_data.values, from_rows: true))
      end

      it "shows the configuration" do
        expected_output = <<~OUTPUT
          Id: test_config
          Name: Client Co.
          Client Name: 1234 Elm Street
          Client Address: 123456789
          Client Vat: Beneficiary Name
          Beneficiary Name: 987654321
          Beneficiary Tax Number: 4321 Oak Avenue
          Beneficiary Address: Bank Beneficiary
          Bank Account Beneficiary Name: 5678 Pine Blvd
          Bank Account Address: IBAN1234567890
          Bank Account Iban: SWIFT12345
          Bank Account Swift: Big Bank
          Bank Name: 30d
          Payment Terms: Consulting services
          Service Description: sequential
          Invoice Numbering:#{" "}
        OUTPUT

        expect { configuration_commands.show(config_name) }
          .to output(expected_output).to_stdout
      end
    end
  end
end
