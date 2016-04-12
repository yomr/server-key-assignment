require 'sqlite3'

class DB
  def initialize
    @db = SQLite3::Database.new('/Users/Yohan.m/GitHub/Ruby-assignment-3/assignment3.db')
  end
  
  def push_new_keys(keys)
    keys.each { |k, v|
      @db.execute("INSERT INTO key_store(key, state, keep_alive_time) VALUES ('#{k}', '#{v}', DATETIME('now', '+5 minutes'))")
    }
  end

  def update_state(key, state)
    if state == 'BLOCKED'
      @db.execute("update key_store set state = '#{state}', block_time = DATETIME('now') where key = '#{key}'")
    else
      @db.execute("update key_store set state = '#{state}' where key = '#{key}'")
    end
  end

  def update_keep_alive(key)
    @db.execute("update key_store set keep_alive_time = DATETIME('now', '+5 minutes') where key = '#{key}' ")
  end

  def delete_key(key)
    @db.execute("delete from key_store where key= '#{key}' ")
  end

  def available_key
    key = @db.execute('select key from key_store where state = "AVAILABLE" limit 1')
    key
  end

  def remove_dead_keys
    puts "removing remove_dead_keys"
    @db.execute("delete from key_store where state = 'AVAILABLE' AND keep_alive_time < datetime('now', '-5 minutes')")
  end

  def unblock_stale_keys
    @db.execute("update key_store set state = 'AVAILABLE' where state = 'BLOCKED' and block_time <= datetime('now', '+1 minute')")
  end
end
