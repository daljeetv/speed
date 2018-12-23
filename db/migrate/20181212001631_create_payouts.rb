class CreatePayouts < ActiveRecord::Migration[5.2]
  def change
    create_table :payouts do |t|
      t.references :notification, foreign_key: true
      t.references :reward, foreign_key: true
      t.integer :reward_github_id
      t.integer :rewardee_github_id
      t.date :payout_date
      t.decimal :payout_amount
    end
  end
end
