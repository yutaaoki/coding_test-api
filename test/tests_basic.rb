#require 'spec_helper'
require './lib/coding_test/api'
require 'rack/test'
require 'json'

describe CodingTest::API do
  include Rack::Test::Methods

  def app
    CodingTest::API
  end

  describe CodingTest::API do
    describe "GET tests" do
      it "returns 200" do
        get "tests"
        last_response.status.should == 200
      end
    end

    describe "PUT test" do
      it "returns 200" do
        data = {'name' => 'test-simple', 'introduction' => 'sample test', 'codes' => [1 => 'some code']}
        put "tests/test-simple", {'data' => data.to_json}
        last_response.status.should == 200
      end
    end
  end
end

