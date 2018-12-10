class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  def self.create(notification, amount, current_user)

    @reward = current_user.rewards.create!(amount: amount, notification: notification[0], start_date: DateTime.now)
    Rails.logger.info("reward class: #{@reward.class.name}" )
    @reward.save

  end

end
