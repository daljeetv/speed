class AddBountyToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :bounty, :price, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end
end
