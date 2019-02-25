class Request < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  def self.create(notification, amount, current_user)
    @request = current_user.requests.create!(amount: amount, notification: notification[0], start_date: DateTime.now)
    result = {
        error: false,
        message: "Successfully created request for \"#{notification[0].subject_title}\" for $#{amount}"
    }
    return result
  end
end



