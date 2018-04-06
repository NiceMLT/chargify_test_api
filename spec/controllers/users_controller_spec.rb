require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST create" do
    it "creates a new User" do
      expect { post :create, user: { name: "Anew Yooser", email: "anew@yooser.com" }}.to change(User, :count).by(1)
    end
  end
end
