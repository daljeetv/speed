class AddPayoutStripeIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_credit_card_token, :string
    add_column :users, :stripe_payout_code, :string
    add_column :users, :stripe_payout_token_type, :string
    add_column :users, :stripe_payout_stripe_publishable_key, :string
    add_column :users, :stripe_payout_scope, :string
    add_column :users, :stripe_payout_livemode, :string
    add_column :users, :stripe_payout_stripe_user_id, :string
    add_column :users, :stripe_payout_refresh_token, :string
    add_column :users, :stripe_payout_access_token, :string

  end
end
