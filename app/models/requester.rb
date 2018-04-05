class Requester

  def initialize
    auth = { username: 'billing', password: 'gateway' }
    @request ||= HTTParty.get('http://localhost:4567/validate', basic_auth: auth, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def status
    @request.response.code.to_i
  end

  def error?
    status != 200
  end

  def success?
    !error?
  end

  def body
    return {} if error?
    @body ||= JSON.parse(@request.response.body)
  end

  def paid?
    success? && body["paid"]
  end

  def insufficient_funds?
    success? && !body["paid"]
  end

  def payment_id
    return body["id"] if success?
  end
  #{"id"=>"c322a26ccb291c1b", "paid"=>false, "failure_message"=>"insufficient_funds"}
  #{"id"=>"3e3136132d4b7bb3", "paid"=>true, "failure_message"=>nil}
end
