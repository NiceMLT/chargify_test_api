class Subscription < ActiveRecord::base
  has_many: subscriptions
##TODO:need to run this migration still
  def as_json
    {
      id: id,
      name: name,
      email: email
    }
  end
end
