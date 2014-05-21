require './lib/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  def res200
    expect(last_response.status).to eq(200)
  end

  describe "Auth" do
    include_examples :auth_tests, "sessions"
  end

  describe "sessions" do

    before(:each) do
      auth
    end

    it "GET sessions" do
      get "sessions"
      res200
    end

    it "POST sessions" do
      data = {name: 'spec_session_put', introduction: 'Put your hands in the air!', codes: [1 => 'some code']}
      post "sessions", {data: data.to_json}
      expect(last_response.status).to eq(201)
    end

    it "DELETE sessions" do
      delete "sessions/spec_sessions"
      res200
    end

  end

end
