class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.references :user, foreign_key: true
      t.references :notification, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :amount, null: 0.0
      t.string :distributed_to
      t.datetime :distribute_date
      t.datetime :payout_date
      t.timestamps
    end
  end
end

