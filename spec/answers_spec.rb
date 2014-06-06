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
    it 'GETs nonexistent answer' do
      get "answers/blablabla"
      assert_status(404)
    end

    it 'GETs an answer' do
      id = create_session
      location = start_session(id)
      data = {session_id: id, instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
      put "answers/#{id}", {data: data.to_json}
      assert200
      get "answers/#{id}"
      assert200
    end

    it 'PUTs nonexistent session' do
      data = {session_id: 'lalala', instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
      put "answers/blablabla", {data: data.to_json}
      assert_status(404)
    end

    it 'PUTs an answer' do
      id = create_session
      location = start_session(id)
      data = {session_id: id, instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
      put "answers/#{id}", {data: data.to_json}
      assert200
    end

    it 'PUTs a finished answer' do
      id = create_session
      location = start_session(id)
      put "sessions/#{id}/time"
      data = {session_id: id, instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
      put "answers/#{id}", {data: data.to_json}
      assert_status(405)
    end
  end

end
