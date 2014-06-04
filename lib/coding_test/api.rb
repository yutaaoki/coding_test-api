require 'grape'
require_relative 'data_access'

module CodingTest
  class API < Grape::API
    format :json


    get do
      { message: "Welcome to CodingTest Api" }
    end

    ##################
    # Public
    #################

    resource :sessions do

      get ':id' do
        data = DataAccess::get_session(params[:id])
        if data == nil
          error! 'Session Not Exist', 404
        elsif data['started']
          data
        else
          data.slice!(:instruction)
        end
      end

      post ':id' do
        data = DataAccess::get_session(params[:id])
        if data == nil
          error! 'Session Not Exist', 404
        elsif data['started']
          error! 'Test Already Started', 405, 'Allow' => 'GET'
        else
          time = Time.now.to_i
          data['started'] = time
          DataAccess::update_session data['_id'], data
          {location: "sessions/#{params[:id]}/content"}
        end
      end

      get ':id/time' do
        data = DataAccess::get_session(params[:id])
        if data == nil
          error! 'Session Not Exist', 404
        elsif data['started']
          time = Time.new(data['started'].to_i)
          dif = Time.now - time
          {remaining: dif/60}
        else
          error! 'Session Not Started', 404
        end
      end

      get ':id/content' do
        data = DataAccess::get_session(params[:id])
        if data == nil
          error! 'Session Not Exist', 404
        elsif data['started']
          data
        else
          error! 'Session Not Started', 404
        end
      end
    end

    ##################
    # Restricted 
    #################
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
