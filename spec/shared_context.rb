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

  def assert_status(code)
    expect(last_response.status).to eq(code)
  end

  def assert_body(body)
    expect(last_response.body).to eq(body)
  end

  def assert_body_regex(reg)
    expect(last_response.body).to match(reg)
  end

  def create_session
      auth
      data = {name: 'spec_run_session_prepare', instruction: 'Put your hands in the air!', codes: [1 => 'some code']}
      post "sessions", {data: data.to_json}
      assert201
      data = JSON.parse(last_response.body)
      data["_id"]
  end

  def start_session(id)
      post  "sessions/#{id}"
      assert201
      assert_body_regex /location/
      data = JSON.parse(last_response.body)
      data['location']
  end
  
  def db
    client = Mongo::MongoClient.new(Host)
    db = client.db(DBName)
  end

  def tests
    db['tests']
  end

  def sessions
    db['sessions']
  end

  before(:all) do
    tests.remove("name" => /spec.+/)
    sessions.remove("name" => /spec.+/)
  end
  
  after(:all) do
    tests.remove("name" => /spec.+/)
    sessions.remove("name" => /spec.+/)
  end

end

