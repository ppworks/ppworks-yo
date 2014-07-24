require File.dirname(__FILE__) + '/spec_helper'

describe "App" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  before do
    ENV['YO_CALLBACK_PATH'] = yo_callback_path
    ENV['MESSAGES'] = message
    client = double(Twitter::REST::Client)
    allow(client).to receive(:update).with(update_message).and_return(true)
    allow(Twitter::REST::Client).to receive(:new).and_return(client)
  end

  let(:yo_callback_path) { 'yo_callback_path' }
  let(:message) { 'hoge' }
  let(:update_message) { "#{message} #{username}さん"}

  describe 'API access' do
    context 'has YO_CALLBACK_PATH' do
      before do
        get "/#{yo_callback_path}", username: username
      end
      context 'has username parameter' do
        let(:username) { 'ppworks' }
        it { expect(last_response).to be_ok }
      end

      context 'has no username parameter' do
        let(:username) { nil }
        it { expect(last_response.status).to eq 400 }
      end
    end

    context 'has invalid YO_CALLBACK_PATH' do
      before do
        get "/hoge", username: username
      end
      context 'has username parameter' do
        let(:username) { 'ppworks' }
        it { expect(last_response.status).to eq 400 }
      end

      context 'has no username parameter' do
        let(:username) { nil }
        it { expect(last_response.status).to eq 400 }
      end
    end

    context 'has no YO_CALLBACK_PATH' do
      before do
        get "/", username: username
      end
      context 'has username parameter' do
        let(:username) { 'ppworks' }
        it { expect(last_response.status).to eq 404 }
      end

      context 'has no username parameter' do
        let(:username) { nil }
        it { expect(last_response.status).to eq 404 }
      end
    end
  end
end
