require 'grape'
require_relative 'data_access'

module CodingTest
  class API < Grape::API
    format :json

    get do
      { "message" => "Welcome to CodingTest Api" }
    end

    # Sessions
    resource :sessions do
      
      http_digest({realm: 'CodingTest Api', opaque: 'Soca tun up!' }) do |username, password|
        { 'test' => 'test' }[username]
      end

      get do
        'Work on meh!'
      end
    end

    # Tests
    resource :tests do

      get do
        DataAccess::all_tests
      end

      params do
        requires :id, type: String, desc: "Test name."
        requires :data, type: String, desc: "Test data."
      end
      put ':id' do
        DataAccess::update_test params[:id], params[:data]
      end

    end

  end
end
