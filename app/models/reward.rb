class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :notification

    def self.create(notification, amount, current_user)
    # if current_user.stripe_id.blank?
    #   result = {
    #       error: true,
    #       message: 'Reward unsuccessful. Please update your payment method in settings.'
    #   }
    #   return result
    # else
      # @reward = current_user.rewards.create!(amount: amount, notification: notification[0], start_date: DateTime.now)
      # self.charge(notification[0], @reward)
      # result = {
      #     error: false,
      #     message: "Successfully created reward for \"#{notification[0].subject_title}\" for $#{amount}"
      # }
      # return result
    # end

    @reward = current_user.rewards.create!(amount: amount, notification: notification[0], start_date: DateTime.now)
      self.charge(notification[0], @reward)
      
      # dstr1 = current_user.github_login
      # dstr2 = notification[0].repository_full_name
      # dstr3 = notification[0].url.split('/').last
      dstr1 = "saravanabalagi"
      dstr2 = "super_mario_stitching"
      dstr3 = 1
      Rails.logger.info("Debug message: #{dstr1} #{dstr2} #{dstr3}")


      github = Github.new
      comments = github.issues.comments.all dstr1, dstr2, dstr3
      Rails.logger.info("Debug message: #{comments[0].body}") unless comments.length==0 and comments[0].body.nil?

      result = {
          error: false,
          message: "Successfully created reward for \"#{notification[0].subject_title}\" for $#{amount}"
      }
      return result
  end

  def self.distribute(selected_rewards, rewardee)
    Rails.logger.info("Distributing #{selected_rewards} rewardee: #{rewardee}")
    reward = selected_rewards[0]
    reward.update(distributed_to: rewardee, distributed_date: DateTime.now);
    flash_message = "Successfully distributed reward: \"#{reward.notification.subject_title}\" to Github user: #{reward.distributed_to}"
    reward.save
    return flash_message
  end

  def self.accept(selected_rewards)
    reward = selected_rewards[0]
    reward.update(payout_date: DateTime.now)

    if reward.user.stripe_payout_stripe_user_id.nil?
      result = {
          error: true,
          message: 'Please update payout method in settings to receive reward.'
      }
      return result
    end
    Rails.logger.info("Payout functionality is okay for #{reward.user.stripe_payout_stripe_user_id}")
    transfer = Stripe::Transfer.create(
        # must be integer in cents
        :amount => Integer(reward.amount),
        :currency => "usd",
        :destination => reward.user.stripe_payout_stripe_user_id,
        :transfer_group => reward.id
    )
    Rails.logger.info("Got transfer #{transfer}")
    if transfer
      flash_message = "Successfully distributed reward: \"#{reward.notification.subject_title}\" to Github user: #{reward.distributed_to}"
      reward.save
      result = {
          error: false,
          message: flash_message
      }
      return result
    else
      flash_message = "Cannot payout - please update payout method."
      result = {
          error: false,
          message: flash_message
      }
      return result
    end
  end

  private

  def self.charge(notification, reward)
    unless reward.user.stripe_id.blank?
      #get the customer from Stripe and charge her.
      customer = Stripe::Customer.retrieve(reward.user.stripe_id)
      charge = Stripe::Charge.create(
          :customer => customer.id,
          :amount => (reward.amount * 100).to_i,
          :description => notification.subject_title,
          :currency => 'usd',
          :transfer_group => reward.id
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



