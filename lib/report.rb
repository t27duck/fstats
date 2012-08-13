class Report
  def total_usage
    return @total_usage unless @total_usage.nil?
    @total_usage = DataPoint.count
  end

  def total_for_current_month
    return @total_for_current_month unless @total_for_current_month.nil?
    @total_for_current_month = repository(:default).adapter.select("SELECT count(*) FROM data_points WHERE month = #{Time.now.month} AND year = #{Time.now.year}")
  end

  def total_by_user
    return @total_by_user unless @total_by_user.nil?
    @total_by_user = repository(:default).adapter.select("SELECT name, count(*) FROM data_points GROUP BY name ORDER BY count(*) DESC")
  end

  def top_users(num=3)
    return @top_users unless @top_users.nil?
    @top_uesrs = total_by_user[0..(num-1)]
  end

  def max_usage_date
    return @max_usage_date unless @max_usage_date.nil?
    @max_usage_date = repository(:default).adapter.select("SELECT date, count(*) AS total FROM data_points GROUP BY date ORDER BY count(*) DESC LIMIT 1")[0]
  end

  def total_by_weekday
    return @total_by_weekday unless @total_by_weekday.nil?
    @total_by_weekday = repository(:default).adapter.select("SELECT wday, count(*) AS total FROM data_points GROUP BY wday ORDER BY wday_numeric")
  end

  def total_by_month(user_id="All")
    @total_by_month = {} if @total_by_month.nil?
    return @total_by_month[user_id] unless @total_by_month[user_id].nil?
    
    query = repository(:default).adapter.select("SELECT month, year, count(*) AS total FROM data_points GROUP BY year, month ORDER BY year, month")
    
    if user_id != "All"
      user_query = repository(:default).adapter.select("SELECT month, year, count(*) AS total FROM data_points WHERE user_id = \"#{user_id}\" GROUP BY year, month ORDER BY year, month")
    end

    start_date = to_date(query.first[1], query.first[0])
    end_date = to_date(query.last[1], query.last[0])
    
    query = user_query if user_id != "All"
    
    report = []
    (start_date..end_date).each do |current_date|
      if current_date.day == 1
        m = current_date.month
        y = current_date.year
        result = Array(query.select{|r| r[0] == m && r[1] == y}.first)
        if Array(result).empty?
          report << [m,y,0]
        else
          report << result
        end
      end
      current_date += (3600 * 24)
    end
    @total_by_month[user_id] = report.uniq
  end

  def total_by_user_by_month
    return @total_by_user_by_month unless @total_by_user_by_month.nil?
    report = []    
    repository(:default).adapter.select("SELECT DISTINCT name, user_id FROM data_points ORDER BY name").each do |r|
      report << [r[0], total_by_month(r[1])]
    end
    @total_by_user_by_month = report
  end

  def all_users
    return @all_users unless @all_users.nil?
    @all_users = repository(:default).adapter.select("SELECT DISTINCT user_id, name FROM data_points ORDER BY name")
  end

  def fucks_by_user(user_id)
    @fucks_by_user = {} if @fucks_by_ueser.nil?
    return @fucks_by_user[user_id] unless @fucks_by_user[user_id].nil?
    @fucks_by_user[user_id] = repository(:default).adapter.select("SELECT * FROM data_points WHERE user_id = #{user_id} ORDER BY created_at")
  end

  private ######################################################################

  def to_date(year, month, day=1)
    Date.parse("#{year}-#{month}-#{day}")
  end

end
