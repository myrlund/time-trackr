class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :projects
  has_many :registrations
  
  def admin?
    false
  end
  
  include TimeAccumulation
  
  def to_json(options={})
    super(options.merge(methods: [ :total_time_this_week, :total_time_this_month, :total_time_this_year ]))
  end
  
end