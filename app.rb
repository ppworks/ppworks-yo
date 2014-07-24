require 'sinatra'
require 'twitter'
require 'dotenv'

set server: 'webrick'
Dotenv.load

get '/:yo_callback_path' do
  return status 400 unless params[:username]
  return status 400 unless params[:yo_callback_path]==ENV['YO_CALLBACK_PATH']
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['API_KEY']
    config.consumer_secret     = ENV['API_SECRET']
    config.access_token        = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
  end
  message = ENV['MESSAGES'].split(',').sample
  client.update "#{message} #{params[:username]}さん"
end
