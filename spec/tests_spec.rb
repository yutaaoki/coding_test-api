#require 'spec_helper'
require './lib/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  describe "Auth" do
    it "without credentials" do
      get "tests"
      expect(last_response.status).to eq(401)
    end
    it "with bad credentials" do
      digest_authorize 'bad', 'bad'
      get 'tests'
      expect(last_response.status).to eq(401)
    end
    it "with good credentials" do
      auth
      get "tests"
      expect(last_response.status).to eq(200)
    end
  end

  describe "Operation returing 200:" do
    before(:each) do
      auth
    end
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
    before(:each) do
      auth
    end
    it "puts, gets, delets, and verifies a test" do
      name = 'spec_put_get'
      data = {name: name, introduction: 'Put your hands in the air!', codes: [1 => 'some code']}
      #put
      put "tests/#{name}", {data: data.to_json}
      last_response.status.should == 200
      #verify
      get "tests/#{name}"
      last_response.status.should == 200
      res = JSON.parse(last_response.body)
      expect(res['name']).to eq(name)
      #delte
      delete "tests/#{name}"
      last_response.status.should == 200
      #verify
      get "tests/#{name}"
      last_response.status.should == 200
      expect(last_response.body).to eq("null")
    end
    it "puts a lot of tests" do
      def hundred
        name = "spec_put_num"
        (1..100).each do |num|
          iname = name+num.to_s
          data = {name: iname, introduction: 'Put your hands in the air!', codes: [1 => 'some code']}
          yield iname, data
          expect(last_response.status).to eq(200)
        end
      end
      hundred do |iname, data|
        put "tests/#{iname}", {data: data.to_json}
      end
      hundred do |iname, data|
        get "tests/#{iname}"
        res = JSON.parse(last_response.body)
        expect(res["name"]).to eq(iname)
      end
    end
  end
end

