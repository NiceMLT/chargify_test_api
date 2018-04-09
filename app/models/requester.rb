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
    !@request.success?
  end

  def body
    return {} if error?
    @body ||= JSON.parse(@request.response.body)
  end

  def payment_id
    return body["id"] if paid?
  end
end
