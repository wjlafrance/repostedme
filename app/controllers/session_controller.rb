class SessionController < ApplicationController
  before_filter :redirect_logged_in_users, :only => [:login]

  def login
    base_url = "https://account.app.net/oauth/authenticate?"
    # if the user signed out, go to authorize rather than authenticate
    # this page requires the user to specifically re-authorize the app (so they
    # can switch user accounts if they want to)
    base_url = "https://account.app.net/oauth/authorize?" if session[:did_sign_out]
    url = base_url + {
      client_id: CLIENT_ID,
      response_type: "code",
      redirect_uri: finish_login_url,
      scope: "basic stream"
    }.to_query

    redirect_to url
  end

  def finish_login
    json = RestClient.post "https://account.app.net/oauth/access_token",
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      grant_type: "authorization_code",
      redirect_uri: finish_login_url,
      code: params["code"]

    data = ActiveSupport::JSON.decode(json)
    sign_in User.create! token: data["access_token"], username: data["username"], userid: data["user_id"]
    redirect_to root_path
  end

  def logout
    sign_out
    redirect_to root_path
  end

private
  def redirect_logged_in_users
    redirect_to root_path if current_user
  end
end
