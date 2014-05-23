shared_context :api_test_context do
  Host = 'localhost'
  DBName = 'coding_test'
  Auth_User = 'test'
  Auth_Pass = 'test'

  def app
    CodingTest::API
  end

  def auth
    digest_authorize Auth_User, Auth_Pass
  end

  def assert200
    expect(last_response.status).to eq(200)
  end

  def assert201
    expect(last_response.status).to eq(201)
  end

  def assert_body(body)
    expect(last_response.body).to eq(body)
  end

  def assert_body_regex(reg)
    expect(last_response.body).to match(reg)
  end

  client = Mongo::MongoClient.new(Host)
  db = client.db(DBName)
  tests = db['tests']
  sessions = db['sessions']

  before(:all) do
    tests.remove("name" => /spec.+/)
    sessions.remove("name" => /spec.+/)
  end
  
  after(:all) do
    tests.remove("name" => /spec.+/)
    sessions.remove("name" => /spec.+/)
  end

end

