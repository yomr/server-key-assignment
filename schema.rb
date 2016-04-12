require 'sqlite3'

=begin
This script is used by rspec test cases to setup and modify data.
=end
class Schema
  def initialize
    @db = SQLite3::Database.new('assignment3.db')
    @db.execute('drop table key_store')
    @db.execute('CREATE TABLE key_store(key, state, keep_alive_time datetime, block_time datetime)')
  end

  def seed_data
    1.upto(50) {|n|
      @db.execute("INSERT INTO key_store(key, state, keep_alive_time) VALUES ('#{n}', 'AVAILABLE', DATETIME('now', '+5 minutes'))")    
    }

    51.upto(100) { |n|
      @db.execute("INSERT INTO key_store(key, state, keep_alive_time, block_time) VALUES ('#{n}', 'BLOCKED', DATETIME('now', '+5 minutes'), DATETIME('now'))")    
    }
  end

  def set_all_blocked
    @db.execute("update key_store set state= 'BLOCKED'")
  end

  def add_one
    @db.execute("INSERT INTO key_store(key, state, keep_alive_time) VALUES ('12920', 'AVAILABLE', DATETIME('now', '+5 minutes'))") 
  end 
end

