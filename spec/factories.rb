FactoryBot.define do

  factory :user do
    name "Anew Yooser"
    email "anew@yooser.com"
  end

  factory :subscription do
    paid "true"
    billing_date "Thu, 05 Apr 2018"
    cc_number "4011100110011001"
    cc_expiration "0519"
    cc_code "0123"
    cost 100
  end
end
