require 'mongo'

module CodingTest
  module DataAccess
    include Mongo

    module_function

    Host = 'localhost'
    DBName = 'coding_test'

    def db
      client = MongoClient.new(Host)
      client.db(DBName)
    end

    def tests
      db['tests']
    end

    def all_tests
      tests.find.to_a
    end

  end
end
