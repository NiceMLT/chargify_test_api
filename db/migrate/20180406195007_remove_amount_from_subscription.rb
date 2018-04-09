class RemoveAmountFromSubscription < ActiveRecord::Migration[5.1]
  def change
    remove_column :subscriptions, :amount
  end
end
