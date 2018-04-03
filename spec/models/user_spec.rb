require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { User.new(name: "Steve NoJobs", email: "steve@nojobs.com") }

  it "should know it's name" do
    expect(user.name).to eq("Steve nojobs")
  end

  it "should know it's email" do
    expect(user.email).to eq("steve@nojobs.com")
  end
end
