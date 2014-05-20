require 'grape'
require_relative 'data_access'

module CodingTest
  class API < Grape::API
    format :json

    get do
      { "message" => "Welcome to CodingTest Api" }
    end

    add_authentication = 
      http_digest({realm: 'CodingTest Api', opaque: 'Soca tun up!' }) do |username, password|
        { 'test' => 'test' }[username]
      end

    # Sessions
    resource :sessions do
      

      get do
        'Work on meh!'
      end
    end

    # Tests
    resource :tests do

      add_authentication

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

      get ':id' do
        DataAccess::get_test params[:id]
      end

      delete ':id' do
        DataAccess::delete_test params[:id]
      end

    end

  end
end
