class ChangeIntegersToStrings < ActiveRecord::Migration[5.1]
  def change
    change_column :subscriptions, :cc_number, :string
    change_column :subscriptions, :cc_expiration, :string
    change_column :subscriptions, :cc_code, :string
  end
end
