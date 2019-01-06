class RewardsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_web_or_api!
  helper_method :selected_rewards


  # Distribute rewards to selected issues
  #
  # :category: Notifications Actions
  #
  # ==== Parameters
  #
  # * +:id - The Id of issue you'd like to reward.
  # * +:amount - The value of the reward
  #
  # ==== Example
  #
  # <code>POST rewards/reward_selected?id=123?value=100.00</code>
  #   HEAD 204
  #
  def distribute
    message = Reward.distribute(selected_rewards, params[:rewardee])
    if request.xhr?
      head :ok
      flash[:success] = message
    else
      redirect_back fallback_location: root_path
    end
  end

  def accept
    result = Reward.accept(selected_rewards)
    message = result[:message]
    if request.xhr?
      if result[:error]
        flash[:error] = message
      else
        flash[:success] = message
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  private

  def selected_rewards
    Reward.where(id: params[:id])
  end

  def authenticate_user!
    return if logged_in?
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { "error" => "unauthorized" }, status: :unauthorized }
    end
  end

  def authenticate_web_or_api!
    return if logged_in?
    respond_to do |format|
      format.html { render 'pages/home' }
      format.json { authenticate_user! }
    end
  end
end