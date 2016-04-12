# myapp.rb
require 'sinatra'
require_relative 'api'

get '/' do
  [404, 'oops']
end

get '/generate-keys' do
  api = Api.new
  number_of_keys_to_generate = params['number_of_keys']
  if number_of_keys_to_generate
    number_of_keys_generated = api.generate_keys(number_of_keys_to_generate.to_i)
  else
    number_of_keys_generated = api.generate_keys
  end

  "hey, #{number_of_keys_generated} keys generated"
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
  api.unblock_key(key)
  'Unblocked'
end

get '/delete' do
  key = params['key']
  api = Api.new
  api.delete_key(key)
  'Deleted'
end

get '/keep-alive' do
  key = params['key']
  api = Api.new 
  api.keep_alive(key)
  'Updated Keep Alive time'
end

