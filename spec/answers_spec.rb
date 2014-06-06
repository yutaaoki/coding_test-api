require './app/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  describe 'answers' do
    describe 'GET' do

      it 'returns answer data' do
        id = create_session
        location = start_session(id)
        data = {session_id: id, instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
        put "answers/#{id}", {data: data.to_json}
        assert200
        get "answers/#{id}"
        assert200
        assert_body_regex(/instruction/)
      end

      context "when doesn't exist" do
        it 'returns 404' do
          get "answers/blablabla"
          assert_status(404)
        end
      end
    end

    describe "PUT" do

      it 'returns 200' do
        id = create_session
        location = start_session(id)
        data = {session_id: id, instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
        put "answers/#{id}", {data: data.to_json}
        assert200
      end

      context "when deosn't exist" do
        it 'returns 404' do
          data = {session_id: 'lalala', instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
          put "answers/blablabla", {data: data.to_json}
          assert_status(404)
        end
      end

      context "when already finished" do
        it 'returns 405' do
          id = create_session
          location = start_session(id)
          put "sessions/#{id}/time"
          data = {session_id: id, instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
          put "answers/#{id}", {data: data.to_json}
          assert_status(405)
        end
      end
    end
  end
end
