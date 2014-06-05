require './lib/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

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
      include_examples :session_errors, "time"
      it "GETs" do
        id = create_session
        start_session(id)
        get "sessions/#{id}/time"
        assert200
        assert_body_regex /remaining/
      end
      it 'PUTs' do
        id = create_session
        start_session(id)
        put "sessions/#{id}/time"
        assert200
      end
    end

    describe ':id/content' do
      include_examples :session_errors, "content"
      it 'GETs content' do
        id = create_session
        location = start_session(id)
        get "sessions/#{id}/content"
        assert_body_regex /instruction/
      end
    end

  end

end
