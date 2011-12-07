class Project < ActiveRecord::Base
  acts_as_url :title

  attr_accessible :title, :description, :user
  
  has_many :registrations
  belongs_to :user
  
  validates_presence_of :title, :user
  
  def to_param
    "#{id}-#{url}"
  end
  
  def to_s
    title
  end
  
  def to_json(options={})
    super(options.merge(methods: [ :total_time, :total_time_this_week, :total_time_last_week, :total_time_last_weeks ]))
  end
  
  include TimeAccumulation
  
end
