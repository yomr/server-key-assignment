require 'securerandom'
require_relative 'db.rb'

class Api
  def initialize
    @db_conn = DB.new
  end

  def generate_keys(number_of_keys = 100)
    keys = {}
    state = 'AVAILABLE'
    number_of_keys.times {
      key = SecureRandom.base64(16).gsub(/=+$/,'') 
      keys[key] = state
    }
    @db_conn.push_new_keys(keys)
    number_of_keys
  end

  def allocate_key
    @available_key = @db_conn.available_key
    print "@available_key", @available_key.empty?
    if !@available_key.empty?
      key = @available_key[0][0]
    else
      key = nil
    end
    print "key", key, key.class
    @db_conn.update_state(key, 'BLOCKED') if key
    key
  end

  def unblock_key(key)
    @db_conn.update_state(key, 'AVAILABLE')
  end

  def delete_key(key)
    @db_conn.delete_key(key)
  end

  def keep_alive(key)
    @db_conn.update_keep_alive(key)
  end
end
