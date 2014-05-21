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
