class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true
      t.references :notification, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :amount, null: 0.0
      t.timestamps
    end
  end
end
