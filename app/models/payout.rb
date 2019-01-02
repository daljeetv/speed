require 'net/http'
require 'json'

class Payout < ApplicationRecord
  belongs_to :user
  belongs_to :notification
  has_many :rewards

  def self.create(notification, payout_amount, rewarder, rewardee)

    user_id = User.where("github_id = #{rewarder.github_id}").ids[0]
    total_payouts_paid = 0.0
    total_rewards_amount = 0.0

    Rails.logger.info("Payout amount #{payout_amount} and total_payouts_paid #{total_payouts_paid}")
    if total_rewards_amount < total_payouts_paid
      Rails.logger.info("This is already paid.")
    elsif total_rewards_amount < (payout_amount + total_payouts_paid)
      Rails.logger.info("This is more than the reward amount")
    else
      rewards = Reward.where(notification_id: notification[0].id, user_id: user_id)
      # payout the difference
      @payout = Payout.create!(
          payout_amount: payout_amount,
          reward_github_id: rewarder.github_id,
          rewardee_github_id: get_github_id(rewardee),
          notification: notification[0],
          payout_date: DateTime.now,
          reward_id: rewards[0].id)

      customer = Stripe::Customer.retrieve(rewards[0].user.stripe_id)
      transfer = Stripe::Transfer.create(
          :amount => payout_amount,
          :currency => "usd",
          :destination => customer,
          :transfer_group => rewards[0].notification.id
      )
      Rails.logger.info("Got back transfer resp #{transfer}")
      if transfer
        Rails.logger.info('Reward created successfully!')
        flash_message = "Reward created successfully!"
        @payout.save
        return flash_message
      else
        Rails.logger.warn('Cannot charge with this payment method!')
        flash_message = "Cannot charge with this payment method!"
        return flash_message
      end
    end
  end

  private

  def self.get_github_id(rewardee)
    url = URI.parse('https://api.github.com/users/' + rewardee)
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    resp = http.request(req)
    parsed_resp = ActiveSupport::JSON.decode(resp.body)
    parsed_resp['id']
  end

  def self.get_total_payout(notification)
    total_payout_value = 0

    for payout in payouts do
      Rails.logger.info("Payout found: #{payout}")
      total_payout_value += payout.payout_amount
    end
    total_payout_value
  end

end