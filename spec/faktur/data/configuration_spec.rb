# frozen_string_literal: true

require "sqlite3"
require_relative "../../../lib/faktur/data/configuration"
require_relative "../../../lib/faktur/database"
require_relative "../../../lib/faktur/models/configuration"

RSpec.describe Faktur::Data::Configuration do
  let(:db) { double("SQLite3::Database") }
  let(:data) { { key: "value" } }
  let(:table_name) { "configs" }

  before do
    allow(Faktur::Database).to receive(:setup)
    allow(Faktur::Database).to receive(:create)
    allow(Faktur::Database).to receive(:list).and_yield([])
    allow(Faktur::Database).to receive(:delete)
    allow(db).to receive(:execute)
  end

  describe ".create" do
    it "sets up the database and creates a configuration" do
      expect(Faktur::Database).to receive(:setup)
      expect(Faktur::Database).to receive(:create).with(table_name, data)

      described_class.create(data)
    end
  end

  describe ".list" do
    it "lists configurations" do
      expect(Faktur::Database).to receive(:list).with(table_name, {})

      described_class.list
    end
  end

  describe ".find_by" do
    it "finds a configuration by criteria" do
      expect(described_class).to receive(:list).with({ key: "value" }).and_return([double])

      described_class.find_by({ key: "value" })
    end
  end

  describe ".delete" do
    it "deletes a configuration by criteria" do
      expect(Faktur::Database).to receive(:delete).with(table_name, { key: "value" })

      described_class.delete({ key: "value" })
    end
  end

  describe ".execute_update" do
    it "executes an update on the database" do
      expect(db).to receive(:execute).with(
        "UPDATE #{table_name} SET key = ? WHERE id = ?",
        ["value", 1]
      )

      described_class.execute_update(db, table_name, 1, key: "value")
    end
  end
end
