shared_examples :auth_tests do |uri|
  it "without credentials" do
    get uri 
    expect(last_response.status).to eq(401)
  end
  it "with bad credentials" do
    digest_authorize 'bad', 'bad'
    get uri
    expect(last_response.status).to eq(401)
  end
  it "with good credentials" do
    auth
    get uri
    expect(last_response.status).to eq(200)
  end
end

shared_examples :session_errors do |path|
  it 'GETs nonexistent session' do
    get "sessions/blablabla/#{path}"
    assert_status(404)
  end
  it 'GETs session Not Started' do
    id = create_session
    get "sessions/#{id}/#{path}"
    assert_status(404)
  end
  it "GETs a finished session" do
    id = create_session
    start_session(id)
    put "sessions/#{id}/time"
    get "sessions/#{id}/#{path}"
    assert_status(404)
  end
end
