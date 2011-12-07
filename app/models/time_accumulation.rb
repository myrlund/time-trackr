module TimeAccumulation
  
  def total_time(options={})
    self.registrations.total_duration(options)
  end
  
  def total_time_this_week
    total_time_week_n_ago(0)
  end
  
  def total_time_this_month
    total_time_month_n_ago(0)
  end
  
  def total_time_this_year
    total_time(from: DateTime.now.beginning_of_year, to: DateTime.now.end_of_year)
  end
    
  def total_time_last_week
    total_time_week_n_ago(1)
  end
  
  def total_time_last_weeks(n=5)
    {}.tap do |hash|
      0.upto n do |i|
        hash[i] = total_time_week_n_ago(i)
      end
    end
  end
  
  def total_time_week_n_ago(n=0)
    total_time(from: DateTime.now.beginning_of_week - n.weeks, to: DateTime.now.end_of_week - n.weeks)
  end
  
  def total_time_month_n_ago(n=0)
    total_time(from: DateTime.now.beginning_of_month - n.months, to: DateTime.now.end_of_month - n.months)
  end
  
end