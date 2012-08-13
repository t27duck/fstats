class User
  @@stored_users = []

  attr_accessor :id
  attr_accessor :name

  def self.find(user_id)
    user = @@stored_users.detect{|u| u.id == user_id.to_i}
    return user unless user.nil?
    data = Campfire.new.user(user_id)["user"]
    user = new.tap do |u|
      u.id = data["id"].to_i
      u.name = data["name"]
    end
    @@stored_users << user
    user
  end
end
