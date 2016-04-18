# myapp.rb
require 'sinatra'
require_relative 'api'
require_relative 'db'
require_relative 'keep_alive_handler'
require_relative 'unblock_handler'

def initialize
  @db_conn = DB.new
end

get '/' do
  [404, 'oops']
end

get '/generate-keys' do
  api = Api.new @db_conn
  number_of_keys_to_generate = params['number_of_keys']
  begin
    if number_of_keys_to_generate
      number_of_keys_generated = api.generate_keys(number_of_keys_to_generate.to_i)
    else
      number_of_keys_generated = api.generate_keys
    end
    [200, "#{number_of_keys_generated} keys generated"]    
  rescue StandardError => e
    [422, "#{e}"]
  end
end

get '/get-key' do
  api = Api.new @db_conn
  key = api.allocate_key
  if key
    [200, key]
  else
    [404, 'No key available']
  end
end

get '/unblock' do
  key = params['key']
  api = Api.new @db_conn
  begin
    api.unblock_key(key)
    [200, 'Unblocked']
  rescue StandardError => e
    [404, "#{e}"]
  end
end

get '/delete' do
  key = params['key']
  api = Api.new @db_conn
  begin
    api.delete_key(key)
    [200, 'deleted']
  rescue StandardError => e
    [404, "#{e}"]
  end
end

get '/keep-alive' do
  key = params['key']
  api = Api.new @db_conn
  begin
    api.keep_alive(key)
    [200, 'Updated Keep Alive time']
  rescue StandardError => e
    [404, "#{e}"]
  end
end


keep_alive_thread = Thread.new do
  while true  
    sleep(300)
    puts "executing keep_alive"
    KeepAliveHandler.new @db_conn
  end
end

unblock_thread = Thread.new do
  while true
    sleep(60)
    puts "executing unblock_thread"
    UnblockHandler.new @db_conn
  end    
end

initialize


