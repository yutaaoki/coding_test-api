require './lib/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  describe 'run/sessions' do

    it "GET nonexistent id" do
      get "run/sessions/#{SecureRandom.uuid}"
      assert200
      assert_body('{}')
    end

    it "PUT noexistent id" do
      put "run/sessions/#{SecureRandom.uuid}"
      assert200
      expect(last_response.body).to match(/start.+/)
    end
  end

end
