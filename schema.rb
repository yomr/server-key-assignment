require 'sqlite3'

class Schema
  def initialize
    @db = SQLite3::Database.new('assignment3.db')
    @db.execute('CREATE TABLE key_store(key, state, keep_alive_time datetime, block_time datetime)')
  end
end

Schema.new