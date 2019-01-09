# frozen_string_literal: true
class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def letsencrypt
    # use your code here, not mine
    render plain: ENV['LETS_ENCRYPT_CODE']
  end
end
