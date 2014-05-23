require 'grape'
require_relative 'data_access'

module CodingTest
  class API < Grape::API
    format :json

    get do
      { message: "Welcome to CodingTest Api" }
    end

    # Run
    resource :run do

      resource :sessions do

        get ':id' do
          data = DataAccess::get_session(params[:id]) || {}
          if data['started']
            data
          else
            data.slice!(:instruction)
          end
        end

        put ':id' do
          data = DataAccess::get_session(params[:id]) || {}
          if data['started']
            data.slice!(:started)
          else
            data['started'] = Time.now
            DataAccess::update_session data['_id'], data
            data.slice!(:started)
          end
        end
      end
    end

    http_digest({realm: 'CodingTest Api', opaque: 'Soca tun up!' }) do |username, password|
      { 'test' => 'test' }[username]
    end

    # Sessions
    resource :sessions do

      get do
        DataAccess::get_sessions
      end

      params do
        requires :data, type: String, desc: "Session Data"
      end
      post do
        data = JSON.parse(params[:data])
        # add uuid
        data['_id'] = SecureRandom.uuid
        DataAccess::insert_session data
        data
      end

      delete ':id' do
        DataAccess::delete_session params[:id]
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

      get ':id' do
        DataAccess::get_test params[:id]
      end

      delete ':id' do
        DataAccess::delete_test params[:id]
      end
    end

  end
end
