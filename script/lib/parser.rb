class Parser

  def generate_data
    print "Getting data from 37Signals Campfire"
    page = -1
    begin
      print "."
      data = parse Campfire.new.search(page += 1)["messages"]
    end while !data.empty? #&& page < 3
    puts "done"
  end

  private ####################################################################
  
  def parse(data)
    data.each do |message|
      next unless Fstats.config["room_id"] == message["room_id"]
      next unless user_we_care_about?(message["user_id"].to_i)
      user = User.find(message["user_id"])
      created_at = Date.parse(message["created_at"])
      DataPoint.create({
        :name => user.name,
        :user_id => message["user_id"].to_i,
        :message => message['body'],
        :wday => created_at.strftime("%A"),
        :wday_numeric => created_at.strftime("%w"),
        :month => created_at.month,
        :year => created_at.year,
        :date => created_at.strftime("%Y-%m-%d"),
        :created_at => created_at
      })
    end
  end

  def user_we_care_about?(user_id)
    return true if Fstats.config["excluded_user_ids"].empty?
    return !Fstats.config["excluded_user_ids"].include?(user_id)
  end
end
