require './app/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  describe 'sessions' do

    context "when not exist" do
      it "returns 404" do
        get "sessions/#{SecureRandom.uuid}"
        assert_status(404)
      end
    end

    describe 'sessions' do

      describe 'GET' do
        it "returns data" do
          id = create_session
          assert201
          get "sessions/#{id}"
          assert200
          assert_body_regex(/instruction/)
        end
      end

      describe 'POST' do

        context "when already started" do
          it "returns 405" do
            id = create_session
            post  "sessions/#{id}"
            assert201
            post  "sessions/#{id}"
            assert_status 405
          end
        end

        context "when not exist" do
          it "returns 404" do
            post "sessions/#{SecureRandom.uuid}"
            assert_status(404)
          end
        end
      end
    end

    describe ':id/time' do
      include_examples :session_errors, "time"

      describe "GET" do
        it "returns remaining time" do
          id = create_session
          start_session(id)
          get "sessions/#{id}/time"
          assert200
          assert_body_regex /remaining/
        end
      end

      describe 'PUT' do
        it 'returns 200' do
          id = create_session
          start_session(id)
          put "sessions/#{id}/time"
          assert200
        end
      end
    end

    describe ':id/content' do
      include_examples :session_errors, "content"
      it 'returns data' do
        id = create_session
        location = start_session(id)
        get "sessions/#{id}/content"
        assert_body_regex /instruction/
      end
    end
  end
end
