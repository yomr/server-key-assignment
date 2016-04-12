require_relative 'db.rb'
puts "running gile"
class KeepAliveHandler

  def initialize
    puts "Got into initialize"
    @db_conn = DB.new
    handle
  end

  def handle
    puts "got into hanlde"
    @db_conn.remove_dead_keys
  end
end

KeepAliveHandler.new

