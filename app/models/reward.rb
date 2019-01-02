class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  def self.create(notification, amount, current_user)
    if current_user.stripe_id.blank?
      result = {
          error: true,
          message: 'Reward unsuccessful. Please update your payment method in settings.'
      }
      return result
    else
      @reward = current_user.rewards.create!(amount: amount, notification: notification[0], start_date: DateTime.now)
      self.charge(notification[0], @reward)
      result = {
          error: false,
          message: "Successfully created reward for \"#{notification[0].subject_title}\" for $#{amount}"
      }
      return result
    end
  end

  def self.distribute(selected_rewards, rewardee)
    Rails.logger.info("Distributing #{selected_rewards} rewardee: #{rewardee}")
    reward = selected_rewards[0]
    reward.update(distributed_to: rewardee, distribute_date: DateTime.now);
    reward.save
    message = "Successfully distributed reward: \"#{reward.notification.subject_title}\" to Github user: #{reward.distributed_to}"
    Rails.logger.info(message)
    return message
  end

  private

  def self.charge(notification, reward)
    unless reward.user.stripe_id.blank?
      #get the customer from Stripe and charge her.
      customer = Stripe::Customer.retrieve(reward.user.stripe_id)
      charge = Stripe::Charge.create(
          :customer => customer.id,
          :amount => (reward.amount).to_i,
          :description => notification.subject_title,
          :currency => 'usd',
          :transfer_group => reward.notification.id
      )
      # if the charge is successful then approve the reward!
      Rails.logger.info("Got back charge resp #{charge}")
      if charge
        @reward.save
        Rails.logger.info('Reward created successfully!')
        flash_message = "Reward created successfully!"
        return flash_message
      else
        Rails.logger.warn('Cannot charge with this payment method!')
        flash_message = "Cannot charge with this payment method!"
        return flash_message
      end
    end
  rescue Stripe::CardError => e
    reward.declined!
    Rails.logger.warn("Stripe Card Error #{e.message}")
    flash_message = e.message
    return flash_message
  end

  def self.get_total_rewards_amount(notification_ids, user_id)
    rewards = Reward.where(notification_id: notification_ids, user_id: user_id, distributed_to: nil)
    total_rewards_amount = rewards.sum(:amount)
    return total_rewards_amount
  end
end



