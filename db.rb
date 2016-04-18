require 'sqlite3'

class DB
  def initialize
    @db = SQLite3::Database.new('assignment3.db')
    @db.busy_timeout = 5000
  end
  
  def push_new_keys(keys)
    keys.each { |k, v|
      @db.transaction
      @db.execute("INSERT INTO key_store(key, state, keep_alive_time) VALUES ('#{k}', '#{v}', DATETIME('now', '+5 minutes'))")
      @db.commit
    }
  end

  def update_state(key, state)
    @db.transaction      
    if state == 'BLOCKED'
      result = @db.execute("update key_store set state = '#{state}', block_time = DATETIME('now') where key = '#{key}'")
    else
      result = @db.execute("update key_store set state = '#{state}' where key = '#{key}'")
    end
    @db.commit
  end

  def update_keep_alive(key)
    @db.transaction
    result = @db.execute("update key_store set keep_alive_time = DATETIME('now', '+5 minutes') where key = '#{key}' ")
    @db.commit
  end

  def delete_key(key)
    @db.transaction
    result = @db.execute("delete from key_store where key= '#{key}' ")
    @db.commit
  end

  def available_key
    @db.transaction
    key = @db.execute('select key from key_store where state = "AVAILABLE" limit 1')
    @db.commit
    key
  end

  def remove_dead_keys
    @db.transaction
    result = @db.execute("delete from key_store where state = 'AVAILABLE' AND keep_alive_time < datetime('now', '-5 minutes')")
    @db.commit
  end

  def unblock_stale_keys
    @db.transaction
    result = @db.execute("update key_store set state = 'AVAILABLE' where state = 'BLOCKED' and block_time >= datetime('now', '+1 minute')")
    @db.commit
  end

  def key_exists?(key)
    @db.transaction
    result = @db.execute("select key from key_store where key='#{key}'")
    @db.commit
    if !result.empty?
      true
    else 
      false
    end
  end
end
