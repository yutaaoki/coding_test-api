require './lib/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  def create_session
      data = {name: 'spec_run_session_prepare', instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
      post "sessions", {data: data.to_json}
      data = JSON.parse(last_response.body)
      data["_id"]
  end

  describe 'sessions' do

    it "GET nonexistent id" do
      get "sessions/#{SecureRandom.uuid}"
      assert_status(404)
    end

    it "POST and GET session" do
      auth
      id = create_session
      assert201
      get "sessions/#{id}"
      assert200
      assert_body_regex(/instruction/)
    end

    it "POST noexistent id" do
      post "sessions/#{SecureRandom.uuid}"
      assert_status(404)
    end

    it "Create, POST, GET session" do
      auth
      id = create_session
      assert201
      post  "sessions/#{id}"
      assert201
      assert_body_regex /location/
      data = JSON.parse(last_response.body)
      get data['location']
      puts sessions.find.to_a
      assert200
      assert_body_regex /started/
    end

    it "POST twice" do
      auth
      id = create_session
      post  "sessions/#{id}"
      assert201
      post  "sessions/#{id}"
      assert_status 405
    end
  end

end
