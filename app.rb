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
  doc = RestClient.get("#{DB}/_all_docs?include_docs=true")
  @messages = JSON.parse(doc)
  erb :index
end

get '/:id' do
  message = RestClient.get("#{DB}/#{params[:id]}")
  @message = JSON.parse(message)
  erb :message
end
