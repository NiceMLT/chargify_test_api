FactoryBot.define do

  factory :user do
    name "Factoree Botbot"
    email "factoree@botbot.com"
  end

  factory :subscription do
    paid "true"
    billing_date "March 1, 2018"
    cc_number "4011100110011001"
    cc_expiration "0519"
    cc_code "0123"
  end
end
