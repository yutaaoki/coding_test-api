require 'grape'

module CodingTest
  class API < Grape::API
    format :json

    get do
      { "message" => "Welcome to CodingTest Api" }
    end

    resource :sessions do
      
      http_digest({realm: 'CodingTest Api', opaque: 'Soca tun up!' }) do |username, password|
        { 'test' => 'test' }[username]
      end

      get do
        'Work on meh!'
      end
    end
  end
end
