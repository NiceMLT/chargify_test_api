class Requester

  def initialize
    auth = { username: 'billing', password: 'gateway' }
    @request ||= HTTParty.get('http://localhost:4567/validate', basic_auth: auth, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def insufficient_funds?
    body['failure_message'] == 'insufficient_funds'
  end

  def paid?
    body["paid"]
  end

  def error?
    status != 200
  end

  def body
    return {} if error?
    @body ||= JSON.parse(@request.response.body)
  end

  def payment_id
    return body["id"] if paid?
  end
  #{"id"=>"c322a26ccb291c1b", "paid"=>false, "failure_message"=>"insufficient_funds"}
  #{"id"=>"3e3136132d4b7bb3", "paid"=>true, "failure_message"=>nil}
end
