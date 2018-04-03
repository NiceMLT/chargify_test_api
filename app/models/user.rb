class User < ActiveRecord::Base

  has_many :subscriptions

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  validates :name, presence: {message: "is necessary"}

  def as_json
    {
      id: id,
      name: name,
      email: email
    }
  end

end
