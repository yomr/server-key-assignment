require 'securerandom'

class Api
  def initialize(db_conn)
    @db_conn = db_conn
  end

  def generate_keys(number_of_keys = 100)
    keys = {}
    state = 'AVAILABLE'
    begin
      if(number_of_keys.to_i <= 0)
        raise('The number should be grater than 1')
      end
    rescue NoMethodError
      raise('The argument should be an integer')
    end

    number_of_keys.times {
      key = SecureRandom.base64(16).gsub(/=+$/,'') 
      keys[key] = state
    }
    @db_conn.push_new_keys(keys)
    number_of_keys
  end

  def allocate_key
    @available_key = @db_conn.available_key
    if !@available_key.empty?
      key = @available_key[0][0]
    else
      key = nil
    end
    @db_conn.update_state(key, 'BLOCKED') if key
    key
  end

  def unblock_key(key)
    if @db_conn.key_exists?(key)
      @db_conn.update_state(key, 'AVAILABLE')
    else
      raise("Key not found")
    end
  end

  def delete_key(key)
    if @db_conn.key_exists?(key)
      @db_conn.delete_key(key)
    else
      raise("Key not found")
    end
  end

  def keep_alive(key)
    if @db_conn.key_exists?(key)
      @db_conn.update_keep_alive(key)
    else
      raise("Key not found")
    end
  end
end
