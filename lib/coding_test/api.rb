require 'grape'

module CodingTest
  class API < Grape::API
    format :json

    get do
      { "message" => "Hola!" }
    end
  end
end
