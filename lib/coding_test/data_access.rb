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

    def update_test(id, data)
      tests.update({name: id}, JSON.parse(data), :upsert => true)
    end

    def get_test(id)
      tests.find_one({name: id})
    end

    def delete_test(id)
      tests.remove(name: id)
    end

    def sessions
      db['sessions']
    end

    def get_sessions
      sessions.find.to_a
    end

    def get_session(id)
      sessions.find_one({_id: id})
    end
    
    def update_session(id, data)
      sessions.update({_id: id}, data)
    end

    def insert_session(data)
      sessions.insert(data)
    end

    def delete_session(id)
      sessions.remove({_id: id})
    end

  end
end
