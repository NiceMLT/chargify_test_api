require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  # new_subscription

  #good sub
  subscription is persisted in the database if successful

  api returns a message of "subscription created and payment successful" if successful

  #no money
  subscription is not persisted in the database if insufficient funds

  api returns a message of "subscription not created due to insufficient funds" if unsuccessful due to NSF

  #timeout
  subscription charge is retried if the payment gateway times out


  ##bonus
  ## get subscription_info
  returns all valid subscriptions given a user

  returns next billing date for a particular subscription given a subscription id

  ## bonus (should this be in the model?)
  card is returned as valid if it meets validation requirements

  card is returned as invalid if it fails validation requirements
  end

end
