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

  describe "Operation returing 200:" do
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

  describe "Integrated operation" do
    it "puts, gets, and verifies a test" do
      name = 'spec_put_get'
      data = {'name' => name, 'introduction' => 'Put your hands in the air!', 'codes' => [1 => 'some code']}
      put "tests/#{name}", {'data' => data.to_json}
      last_response.status.should == 200
      get "tests/#{name}"
      last_response.status.should == 200
      puts last_response.body
      res = JSON.parse(last_response.body)
      expect(res['name']).to eq(name)
    end
  end
  
end

