class Subscription < ActiveRecord::Base
  has_one :user
end
