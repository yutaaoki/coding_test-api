require 'grape'
require_relative 'data_access'

module CodingTest
  class API < Grape::API
    format :json
    helpers DataAccess

    get do
      { message: "Welcome to CodingTest Api" }
    end

    ##################
    # Public
    #################

    resource :sessions do

      get ':id' do
        data = get_session(params[:id])
        if data == nil
          error! 'Session Not Exist', 404
        elsif data['started']
          data
        else
          data.slice!(:instruction)
        end
      end

      post ':id' do
        data = get_session(params[:id])
        if data == nil
          error! 'Session Not Exist', 404
        elsif data['started']
          error! 'Test Already Started', 405, 'Allow' => 'GET'
        elsif data['finished']
          error! 'Session Already Finished', 405
        else
          time = Time.now.to_i
          data['started'] = time
          update_session data['_id'], data
          {location: "sessions/#{params[:id]}/content"}
        end
      end

      helpers do
        def if_started
          data = get_session(params[:id])
          if data == nil
            error! 'Session Not Exist', 404
          elsif data['finished']
            error! 'Session Already Finished', 405
          elsif data['started']
            yield data
          else
            error! 'Session Not Started', 404
          end
        end
      end

      get ':id/content' do
        if_started do |data|
          data
        end
      end

      get ':id/time' do
        if_started do |data|
          time = Time.new(data['started'].to_i)
          dif = Time.now - time
          {remaining: dif/60}
        end
      end

      put ':id/time' do
        if_started do |data|
          data['finished'] = 'true'
          update_session data['_id'], data
        end
      end
    end

    resource :answers do

      get ':session_id' do
        data = get_answer(params[:session_id])
        if data == nil
            error! 'Answer Not Exist', 404
        else
          data
        end
      end

      params do
        requires :data, type: String, desc: "Answer data."
      end
      put ':session_id' do
          session_data = get_session(params[:id])
          if session_data['finished']
            error! 'Session Already Finished', 405
          end
          update_answer params[:session_id], params[:data]
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
        get_sessions
      end

      params do
        requires :data, type: String, desc: "Session Data"
      end
      post do
        data = JSON.parse(params[:data])
        # add uuid
        data['_id'] = SecureRandom.uuid
        insert_session data
        data
      end

      delete ':id' do
        delete_session params[:id]
      end
    end

    # Tests
    resource :tests do

      get do
        all_tests
      end

      params do
        requires :data, type: String, desc: "Test data."
      end
      put ':id' do
        update_test params[:id], params[:data]
      end

      get ':id' do
        get_test params[:id]
      end

      delete ':id' do
        delete_test params[:id]
      end
    end

  end
end
