class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @tweet = current_user.tweets.build
      @tweets = Tweet.all.order(created_at: "DESC").paginate(page: params[:page], per_page: 10) if logged_in?
    end
  end

  def help
  end

  def about
  end
end
