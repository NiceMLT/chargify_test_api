require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, { user: (name: "Steve Nojobs", email: "steve@nojobs.com") }
        end.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post :create, { user: (name: "Steve Nojobs", email: "steve@nojobs.com") }
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end
    end
  end
end
