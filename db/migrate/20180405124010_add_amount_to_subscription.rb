class AddAmountToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :amount, :integer
  end
end
