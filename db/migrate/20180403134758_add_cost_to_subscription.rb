class AddCostToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :cost, :integer
  end
end
