class Post

  def self.where params
    id = params[:userid] unless params[:userid].nil?
    id = "@#{params[:username]}" unless params[:username].nil?
    return [] unless id # short circuit if nobody is specified

    params = {
      access_token: token_for_user(params[:by_user]),
      count: params[:before_id].nil? ? 25 : 50, # load 50 posts on first call
      include_reposters: 1,
      include_starred_by: 1,
      include_deleted: 0,
      before_id: params[:before_id]
    }

    json = RestClient.get "http://alpha-api.app.net/stream/0/users/#{id}/posts?" + params.to_query
    json = ActiveSupport::JSON.decode(json)

    results = json["data"].map{|post|
      new_fields = { points: post["num_stars"].to_i + post["num_reposts"] }
      if post["num_stars"]  != post["starred_by"].count
        new_fields["starred_by"] = starrers_for_id(post["id"].to_i, token_for_user(params[:by_user]))
      end
      if post["num_reposts"] != post["reposters"].count
        new_fields["reposters"] = reposters_for_id(post["id"].to_i, token_for_user(params[:by_user]))
      end
      post.merge new_fields
    }

    return results, json["meta"]["min_id"]
  end

  def self.reposted_or_starred_where params
    posts, min_id = where params
    results = posts.keep_if {|post|
      post[:points] > 0
    }
    return results, min_id
  end

  def self.reposters_for_id id, token
    params = { access_token: token, count: 200 }
    json = RestClient.get "http://alpha-api.app.net/stream/0/posts/#{id}/reposters?" + params.to_query
    ActiveSupport::JSON.decode(json)["data"]
  end

  def self.starrers_for_id id, token
    params = { access_token: token, count: 200 }
    json = RestClient.get "http://alpha-api.app.net/stream/0/posts/#{id}/stars?" + params.to_query
    ActiveSupport::JSON.decode(json)["data"]
  end

private
  def self.token_for_user requesting_user
    if requesting_user.nil?
      Repostedme::Application::ACCESS_TOKEN
    else
      requesting_user.token
    end
  end

end
