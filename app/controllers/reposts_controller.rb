class RepostsController < ApplicationController

  def user_search
    if params[:user].nil?
      redirect_to root_url
    else
      redirect_to "/u/#{params[:user]}"
    end
  end

  def index
    unless current_user
      redirect_to login_url
      return
    end

    if params[:user].nil?
      redirect_to "/u/#{current_user.username}"
      return
    end

    begin
      json = RestClient.get "http://alpha-api.app.net/stream/0/users/@#{params[:user]}?access_token=" + token_for_user(current_user)
      @user = ActiveSupport::JSON.decode(json)["data"]
      logger.info "request for @#{@user['username']} by @#{current_user.username}"
    rescue RestClient::ResourceNotFound => ex
      @user = nil
    rescue RestClient::Unauthorized => ex
      redirect_to root_url
    end
  end

  def data
    unless current_user
      render json: [], status: 403
      return
    end

    if params[:user].nil?
      render json: [], status: 400
      return
    end

    query = {
      username: params[:user],
      before_id: params[:before_id],
      by_user: current_user
    }

    posts, min_id = Post.reposted_or_starred_where(query)
    render json: {min_id: min_id, posts: posts}
  end

private

  def token_for_user requesting_user
    if requesting_user.nil?
      Repostedme::Application::ACCESS_TOKEN
    else
      requesting_user.token
    end
  end

end
