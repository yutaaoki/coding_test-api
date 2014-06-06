require './app/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  describe "Auth" do
    include_examples :auth_tests, "sessions"
  end

  describe "sessions" do

    before(:each) do
      auth
    end

    describe 'GET' do
      it "returns 200" do
        get "sessions"
        assert200
      end
    end

    describe 'POST' do
      it "returns 201" do
        data = {name: 'spec_session_put', introduction: 'Put your hands in the air!', codes: [1 => 'some code']}
        post "sessions", {data: data.to_json}
        assert201
      end
    end

    describe 'DELETE' do
      it "returns 200" do
        delete "sessions/spec_sessions"
        assert200
      end
    end

    context "when posts and deletes session" do
      it "returns an empty array" do
        name = 'spec_post_scenario'
        data = {name: name, introduction: 'Put your hands in the air!', codes: [1 => 'some code']}
        post "sessions", {data: data.to_json}
        assert201
        get "sessions"
        result = JSON.parse(last_response.body)
        id_node = result.select { |node| node["name"] == name}
        id = id_node[0]["_id"]
        #delete
        delete "sessions/#{id}"
        assert200
        #verify
        get "sessions"
        result2 = JSON.parse(last_response.body)
        empty = result2.select { |node| node["name"] == name}
        expect(empty).to eq([])
      end
    end
  end
end
