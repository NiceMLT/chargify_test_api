require 'rails_helper'

RSpec.describe Subscription, type: :model do
  before(:all) do
    @sub1 = create(:subscription)
  end

  it "should know it's billing_date" do
    expect(@sub1.billing_date).to eq('Thu, 05 Apr 2018')
  end

  it "should know it's cc_number" do
    expect(@sub1.cc_number).to eq('4011100110011001')
  end

  it "should know it's cc_expiration" do
    expect(@sub1.cc_expiration).to eq('0519')
  end

  it "should know it's cc_code" do
    expect(@sub1.cc_code).to eq('0123')
  end
end
