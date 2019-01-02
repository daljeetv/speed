class AddPayoutStripeIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :payout_stripe_id, :string
    add_column :users, :stripe_credit_card_token, :string
  end
end
