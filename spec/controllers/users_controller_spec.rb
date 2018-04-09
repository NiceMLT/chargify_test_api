require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST create' do
    def make_request
      post :create, params: {
        user: {
          name: 'Anew Yooser',
          email: 'anew@yooser.com'
        }
      }
    end

    it 'creates a new user' do
      make_request

      expect(User.last).to have_attributes(
        name: 'Anew Yooser',
        email: 'anew@yooser.com'
      )
    end
  end
end
