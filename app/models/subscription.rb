class Subscription < ActiveRecord::Base

has_many :subscriptions

validates :cc_number, format: { with: ^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$, on: :create }

  def as_json
    {
      id: id,
      user_id: user_id,
      paid: paid,
      billing_date: billing_date,
      amount: amount,
      cc_number: cc_number,
      cc_expiration: cc_expiration,
      cc_code: cc_code
    }
  end
end
