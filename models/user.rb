class UserBlah
  include DataMapper::Resource

  property :id,   Integer, :key => true
  property :name, String

  #has n, :data_points

  def self.fetch(user_id)
    data = Campfire.new.user(user_id)["user"]
    user = new.tap do |u|
      u.id = data["id"].to_i
      u.name = data["name"]
    end
    user.save
    user
  end
end
