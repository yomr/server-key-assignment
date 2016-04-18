class KeepAliveHandler

  def initialize(db_conn)
  	@db_conn = db_conn
  	puts "got into initialize"
    handle
  end

  def handle
    puts "removing dead keys"
    @db_conn.remove_dead_keys
  end
end

