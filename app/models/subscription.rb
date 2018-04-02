class Subscription < ActiveRecord::base
##TODO:need to run this migration still
  def as_json
    {
      id: id,
      user_id: user_id,
      paid: paid,
      billing_date: billing_date
    }
  end
end
