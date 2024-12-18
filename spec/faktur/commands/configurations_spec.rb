# frozen_string_literal: true

require "thor"
require "faktur/commands/configurations"
require "faktur/data/configuration"

RSpec.describe Faktur::Commands::Configurations do
  let(:configurations) { described_class.new }

  describe "#list" do
    let(:configs) { [double("Config", id: 1, name: "Config 1"), double("Config", id: 2, name: "Config 2")] }

    before do
      allow(Faktur::Data::Configuration).to receive(:list).and_return(configs)
      allow(configurations).to receive(:puts)
    end

    it "lists all configurations" do
      configurations.list
      configs.each do |config|
        expect(configurations).to have_received(:puts).with("ID #{config.id} · #{config.name}")
      end
    end
  end

  describe "#show" do
    let(:name) { "Test Configuration" }
    let(:config) { double("Config", client_name: "Client Name", client_address: "Client Address") }
    let(:attrs) { %i[client_name client_address] }

    before do
      stub_const("Faktur::Models::Configuration::ATTRS", attrs)
      allow(Faktur::Data::Configuration).to receive(:find_by).with(name: name).and_return(config)
      allow(configurations).to receive(:puts)
    end

    it "shows a configuration" do
      configurations.show(name)
      attrs.each do |attr|
        expect(configurations).to have_received(:puts).with("#{attr.to_s.split("_").map(&:capitalize).join(" ")}: #{config.send(attr)}")
      end
    end
  end

  describe "#delete" do
    let(:id) { 1 }

    before do
      allow(Faktur::Data::Configuration).to receive(:delete).with({ id: id })
    end

    it "deletes a configuration" do
      configurations.delete(id)
      expect(Faktur::Data::Configuration).to have_received(:delete).with({ id: id })
    end
  end
end
