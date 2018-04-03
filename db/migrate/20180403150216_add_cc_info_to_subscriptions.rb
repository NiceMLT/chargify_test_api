class AddCcInfoToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :cc_number, :integer
    add_column :subscriptions, :cc_expiration, :integer
    add_column :subscriptions, :cc_code, :integer
  end
end
