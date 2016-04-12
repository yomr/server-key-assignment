# myapp.rb
require 'sinatra'
require_relative 'api'

get '/' do
  [404, 'oops']
end

get '/generate-keys' do
  api = Api.new
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
  api = Api.new
  key = api.allocate_key
  if key
    [200, key]
  else
    [404, 'No key available']
  end
end

get '/unblock' do
  key = params['key']
  api = Api.new
  begin
    api.unblock_key(key)
    [200, 'Unblocked']
  rescue StandardError => e
    [404, "#{e}"]
  end
end

get '/delete' do
  key = params['key']
  api = Api.new
  begin
    api.delete_key(key)
    [200, 'deleted']
  rescue StandardError => e
    [404, "#{e}"]
  end
end

get '/keep-alive' do
  key = params['key']
  api = Api.new 
  begin
    api.keep_alive(key)
    [200, 'Updated Keep Alive time']
  rescue StandardError => e
    [404, "#{e}"]
  end
end

