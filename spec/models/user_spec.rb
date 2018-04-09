require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user1 = create(:user)
  end

  it 'is valid with valid attributes' do
    expect(@user1).to be_valid
  end

  it 'has a name' do
    user2 = build(:user, email: 'noname@though.com', name: nil)
    expect(user2).to_not be_valid
  end

  it 'has a unique email' do
    user2 = build(:user, name: 'Noah Email', email: nil)
    expect(user2).to_not be_valid
  end

  it 'is not valid without a name' do
    user2 = build(:user, name: nil)
    expect(user2).to_not be_valid
  end

  it 'is not valid without an email' do
    user2 = build(:user, email: nil)
    expect(user2).to_not be_valid
  end
end
