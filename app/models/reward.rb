class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  def self.create(notification, amount, current_user)
    Rails.logger.info('reward creation begun')
    if current_user.stripe_id.blank?
      Rails.logger.info("Please update your payment method. Currently stripe id: #{current_user.stripe_id}")
      return redirect_to payment_method_path
    else
      @reward = current_user.rewards.create!(amount: amount, notification: notification[0], start_date: DateTime.now)
      self.charge(notification[0], @reward)
    end
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
end



