require './lib/coding_test/api'
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
      puts last_response.body
      assert_status(404)
    end
  end

end
