require 'sinatra'
require 'rest-client'
require 'json'

# if ENV['CLOUDANT_URL']
#   DB = ENV['CLOUDANT_URL'] + '/history'
# else
#   DB = 'localhost:5984' + '/history'
# end

DB = 'https://app4695911.heroku:HecgqPnwGJjNgIHsuJYGshbj@app4695911.heroku.cloudant.com/history'

get '/' do
  limit = 150

  total_messages = (JSON.parse (RestClient.get "#{DB}/_all_docs?limit=0"))['total_rows']
  @total_pages = total_messages / limit

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


private

def total_rows
  doc = RestClient.get "#{DB}/_all_docs?limit=0"
  json_doc = JSON.parse doc
  
  json_doc[:total_rows]
end
