class UnblockHandler

  def initialize(db_conn)
    @db_conn = db_conn
    handle
  end

  def handle
    puts "unblocking stale keys"
    @db_conn.unblock_stale_keys
  end
end
