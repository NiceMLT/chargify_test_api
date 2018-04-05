require 'rails_helper'

RSpec.describe Subscription, :type => :model do

  let(:user) { User.create!(name: "Steve NoJobs", email: "steve@nojobs.com") }
  let(:subscription) { Subscription.create!(user_id: user.id, paid: true, billing_date: "March 1, 2018", cc_number: "4011100110011001", cc_expiration: "0519", cc_code: "0123") }

  it "should know it's billing_date" do
    expect(subscription.billing_date).to eq("March 1, 2018")
  end

  it "should know it's cc_number" do
    expect(subscription.cc_number).to eq("4011100110011001")
  end

  it "should know it's cc_expiration" do
    expect(subscription.cc_expiration).to eq("0519")
  end

  it "should know it's cc_code" do
    expect(subscription.cc_code).to eq("0123")
  end
end
