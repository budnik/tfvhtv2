require 'sinatra'
require 'json'
require 'net/http'
require 'awesome_print'

get '/' do
  redirect '/apple'
end

get '/apple' do
	erb :index
end

post '/apple' do
  @params = ap params

  erb :dialog
end