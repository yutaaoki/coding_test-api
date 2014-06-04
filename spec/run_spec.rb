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
      auth
      data = {name: 'spec_run_session_prepare', instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
      post "sessions", {data: data.to_json}
      data = JSON.parse(last_response.body)
      data["_id"]
  end

  def start_session(id)
      post  "sessions/#{id}"
      assert201
      assert_body_regex /location/
      data = JSON.parse(last_response.body)
      data['location']
  end

  describe 'sessions' do

    it "GET nonexistent id" do
      get "sessions/#{SecureRandom.uuid}"
      assert_status(404)
    end

    describe 'sessions' do
      it "GETs" do
        id = create_session
        assert201
        get "sessions/#{id}"
        assert200
        assert_body_regex(/instruction/)
      end
      it "POSTs twice (already started)" do
        id = create_session
        post  "sessions/#{id}"
        assert201
        post  "sessions/#{id}"
        assert_status 405
      end
      it "POSTs noexistent id" do
        post "sessions/#{SecureRandom.uuid}"
        assert_status(404)
      end
    end

    describe ':id/time' do
      it "GETs" do
        id = create_session
        start_session(id)
        get "sessions/#{id}/time"
        assert200
        assert_body_regex /remaining/
      end
      it 'GETs nonexistent session' do
        get "sessions/blablabla/time"
        assert_status(404)
      end
      it 'GETs Session Not Started' do
        id = create_session
        get "sessions/#{id}/time"
        assert_status(404)
      end
      it 'PUTs' do
        id = create_session
        start_session(id)
        put "sessions/#{id}/time"
        assert200
      end
    end

    describe ':id/content' do
      it 'GETs content' do
        id = create_session
        location = start_session(id)
        get "sessions/#{id}/content"
        assert_body_regex /instruction/
      end
      it 'GETs nonexistent session' do
        get "sessions/blablabla/content"
        assert_status(404)
      end
      it 'GETs Session Not Started' do
        id = create_session
        get "sessions/#{id}/content"
        assert_status(404)
      end
    end

  end

end
