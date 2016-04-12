require_relative 'db.rb'

class UnblockHandler

  def initialize
    @db_conn = DB.new
    handle
  end

  def handle
    puts "got into hanlde"
    @db_conn.unblock_stale_keys
  end
end

UnblockHandler.new