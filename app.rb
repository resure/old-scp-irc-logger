require 'sinatra'
require 'rest-client'
require 'json'

if ENV['CLOUDANT_URL']
  DB = ENV['CLOUDANT_URL'] + '/history'
else
  DB = 'localhost:5984' + '/history'
end

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == ['scpru', '682mustbefree']
end

get '/' do
  limit = 150

  total_messages = (JSON.parse (RestClient.get "#{DB}/_all_docs?limit=0"))['total_rows']
  @total_pages = total_messages / limit + 1

  @page = params[:page].to_i.abs
  @page = @total_pages - 1 if @page > @total_pages - 1
  skip = @page * limit

  query = "#{DB}/_all_docs?&include_docs=true&descending=true&limit=#{limit}&skip=#{skip}"

  doc = RestClient.get query
  @messages = JSON.parse(doc)

  erb :index
end

get '/:id' do
  message = RestClient.get("#{DB}/#{params[:id]}")
  @message = JSON.parse(message)
  erb :message
end
