require_relative 'db.rb'
class KeepAliveHandler

  def initialize
    @db_conn = DB.new
    handle
  end

  def handle
    @db_conn.remove_dead_keys
  end
end

KeepAliveHandler.new

