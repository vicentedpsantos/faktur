# frozen_string_literal: true

require "sqlite3"
require "fileutils"

RSpec.describe Faktur::Database do
  let(:data) { { name: "Test", value: "123" } }
  let(:db_dir) { "./spec/fixtures" }
  let(:db_path) { "#{db_dir}/faktur.db" }
  let(:table_name) { "test_table" }

  before(:all) do
    setup_queries = [
      <<-SQL
        CREATE TABLE IF NOT EXISTS test_table (
          id INTEGER PRIMARY KEY,
          name TEXT,
          value TEXT
        );
      SQL
    ]

    Faktur::Database.setup("./spec/fixtures", setup_queries)
  end

  describe ".setup" do
    it "creates the database file" do
      expect(File).to exist(db_path)
    end
  end
end
