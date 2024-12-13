require "sqlite3"
require_relative "../../lib/faktur/database"
require_relative "../../lib/faktur/sql_queries"

RSpec.describe Faktur::Database do
  let(:db_path) { Faktur::Database::DB_PATH }
  let(:table_name) { "test_table" }
  let(:data) { { name: "Test", value: "123" } }
  let(:updated_data) { { name: "Updated Test", value: "456" } }

  before(:all) do
    Faktur::Database.setup
  end

  before(:each) do
    db = SQLite3::Database.new(db_path)
    db.execute("CREATE TABLE IF NOT EXISTS #{table_name} (id INTEGER PRIMARY KEY, name TEXT, value TEXT)")
    db.close
  end

  after(:each) do
    db = SQLite3::Database.new(db_path)
    db.execute("DROP TABLE IF EXISTS #{table_name}")
    db.close
  end

  describe ".setup" do
    it "creates the database and tables" do
      db = SQLite3::Database.new(db_path)
      tables = db.execute("SELECT name FROM sqlite_master WHERE type='table'")
      expect(tables).not_to be_empty
      db.close
    end
  end

  describe ".create" do
    it "inserts a new record into the table" do
      Faktur::Database.create(table_name, data)
      db = SQLite3::Database.new(db_path)
      result = db.execute("SELECT * FROM #{table_name}")
      expect(result).not_to be_empty
      db.close
    end
  end

  describe ".list" do
    it "lists all records from the table" do
      Faktur::Database.create(table_name, data)
      results = Faktur::Database.list(table_name)
      expect(results).not_to be_empty
    end
  end

  describe ".update" do
    it "updates an existing record in the table" do
      Faktur::Database.create(table_name, data)
      db = SQLite3::Database.new(db_path)
      id = db.execute("SELECT id FROM #{table_name}").first.first
      db.close

      updated_record = Faktur::Database.update(table_name, id, updated_data)
      expect(updated_record).to include(*updated_data.values)
    end
  end

  describe ".get_record" do
    it "retrieves a specific record from the table" do
      Faktur::Database.create(table_name, data)
      db = SQLite3::Database.new(db_path)
      id = db.execute("SELECT id FROM #{table_name}").first.first

      record = Faktur::Database.get_record(db, table_name, id)
      expect(record).to include(*data.values)

      db.close
    end
  end
end
