require './app/coding_test/api'
require 'rack/test'
require 'json'
require 'mongo'
require_relative 'shared_context'
require_relative 'shared_examples'

describe CodingTest::API do
  include Rack::Test::Methods
  include_context :api_test_context

  describe "Auth" do
    include_examples :auth_tests, "tests"
  end

  describe "tests" do
    before(:each) do
      auth
    end
    describe "GET" do
      it "returns 200" do
        get "tests"
        expect(last_response.status).to eq(200)
      end
      context 'when epmtpy' do
        it "GETs tests/spec_empty" do
          get 'tests/spec_empty'
          expect(last_response.status).to eq(200)
        end
      end
    end
    describe 'PUT' do
      it "returns 200" do
        data = {'name' => 'spec_put_test', 'introduction' => 'sample test', 'codes' => [1 => 'some code']}
        put "tests/spec_put_200", {data: data.to_json}
        expect(last_response.status).to eq(200)
      end
    end
    describe 'DELETE' do
      it "returns 200"  do
        delete 'tests/spec_empty'
        expect(last_response.status).to eq(200)
      end
    end
  end

  describe "scenario" do
    before(:each) do
      auth
    end
    context 'when puts a new test and verify' do
      it "returns expected data" do
        name = 'spec_put_get'
        data = {name: name, introduction: 'Put your hands in the air!', codes: [1 => 'some code']}
        #put
        put "tests/#{name}", {data: data.to_json}
        expect(last_response.status).to eq(200)
        #verify
        get "tests/#{name}"
        expect(last_response.status).to eq(200)
        res = JSON.parse(last_response.body)
        expect(res['name']).to eq(name)
        #delte
        delete "tests/#{name}"
        expect(last_response.status).to eq(200)
        #verify
        get "tests/#{name}"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq("null")
      end
    end
    context 'when puts a lot of tests and get them' do
      it "returns each data" do
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
end

