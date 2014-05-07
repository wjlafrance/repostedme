module RepostsHelper
  def user_link user
    link_to "@#{user['username']}", controller: :reposts, action: :index, user: user['username'] # "https://alpha.app.net/#{user['username']}"
  end

  def starrers post
    post["starred_by"].map{|user| user_link(user) }.join(", ")
  end

  def reposters post
    post["reposters"].map {|user| user_link(user) }.join(", ")
  end

  def link_to_post post
    link_to "Permalink", post["canonical_url"] # "https://alpha.app.net/#{post["user"]["username"]}/post/#{post["id"]}"
  end


  def avatar_tag_for_user user, size
    # "<img src=\"https://alpha-api.app.net/stream/0/users/@#{user["username"]}/avatar\" height=\"50\" width=\"50\" />"
    "<img class=\"img-rounded #{size}-avatar\" src=\"#{user["avatar_image"]["url"]}\" />"
  end

  def avatar_line_for_post post
    users = []
    users << post["starred_by"]
    users << post["reposters"]
    users.flatten!
    users.uniq!
    users.map {|user| avatar_tag_for_user user, "small"}.join("")
  end
end
