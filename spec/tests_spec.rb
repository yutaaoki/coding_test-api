#require 'spec_helper'
require './lib/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'

describe CodingTest::API do
  include Rack::Test::Methods

  Host = 'localhost'
  DBName = 'coding_test'

  client = Mongo::MongoClient.new(Host)
  db = client.db(DBName)
  tests = db['tests']

  before(:all) do
    tests.remove("name" => /spec.+/)
  end
  
  after(:all) do
    tests.remove("name" => /spec.+/)
  end

  def app
    CodingTest::API
  end

  describe "Expect 200 from" do
    it "GET tests" do
      get "tests"
      last_response.status.should == 200
    end
    it "GET tests/spec_empty" do
      get 'tests/spec_empty'
      last_response.status.should == 200
    end
    it "PUT tests/spec_put_200" do
      data = {'name' => 'spec_put_test', 'introduction' => 'sample test', 'codes' => [1 => 'some code']}
      put "tests/spec_put_200", {'data' => data.to_json}
      last_response.status.should == 200
    end
    it "DELETE tests/spec_empty"  do
      delete 'tests/spec_empty'
      last_response.status.should == 200
    end
  end

  describe "tests scenarios" do
  end
  
end

