class Registration < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  attr_accessible :project, :description, :start_time, :end_time, :duration

  before_create :calculate_attributes
  before_save :round_times
  
  validates_presence_of :project
  
  MINIMUM_DURATION = 15.minutes
  
  scope :on_day, lambda {|date| in_timespan(date.beginning_of_day, date.end_of_day)}
  scope :in_week, lambda {|date_in_week| in_timespan(date_in_week.beginning_of_week, date_in_week.end_of_week)}
  
  scope :in_timespan, lambda {|start_time, end_time|
    where('start_time >= :start AND start_time <= :end AND end_time >= :start AND end_time <= :end',
      :start => start_time,
      :end => end_time
    )
  }
  
  scope :from, lambda {|start_time| where('start_time >= ?', start_time - 1.minute) }
  scope :until, lambda {|end_time| where('end_time <= ?', end_time + 1.minute) }
  
  def project_title
    if project
      project.title
    else
      nil
    end
  end
  
  def project_title=(value)
    self.project = Project.find_by_title(value)
  end
  
  def start_time=(value)
    super
    
    calculate_attribute(:end_time) if duration.present?
    
    value
  end
  
  def end_time=(value)
    if value < start_time + MINIMUM_DURATION
      value = start_time + MINIMUM_DURATION
    end
    
    super
    
    calculate_attribute(:duration) if start_time.present? and duration != end_time - start_time
    
    end_time
  end
  
  def duration=(value)
    if value < MINIMUM_DURATION
      value = MINIMUM_DURATION
    end
    
    super
    
    calculate_attribute(:end_time) if start_time.present? and end_time != start_time + duration
    
    duration
  end

  class << self
    
    def total_duration(options={})
      options.each{|key, o| options[key] = round_to_nearest_tick(o)}
      
      regs = self
      
      regs = regs.from(options[:from]) if options[:from]
      regs = regs.until(options[:to]) if options[:to]

      nearest_minimum_duration_tick(regs.sum('duration').to_i).seconds + border_registrations(options)
    end
    
    def border_registrations(options={})
      options.each{|key, o| options[key] = round_to_nearest_tick(o)}
      
      time = 0
      
      if options[:from]
        overlaps_start = where('start_time < :from AND end_time > :from', from: options[:from])
        
        overlaps_start.each do |reg|
          if options[:to] && reg.end_time >= options[:to] # overlapper hele spekteret
            time += options[:to].to_i - options[:from].to_i
          else
            time += reg.end_time - options[:from]
          end
        end
      end
      
      if options[:to]
        overlaps_end = where('start_time < :to AND end_time > :to', :to => options[:to] + 1.minute)
        
        overlaps_end.each do |reg|
          if options[:from] && reg.start_time < options[:from] # overlapper hele spekteret
            # Allerede summert i overlaps_start
          else
            time += options[:to].to_i - reg.start_time.to_i
          end
        end
      end
      
      nearest_minimum_duration_tick(time).seconds
    end
    
  end
  
  protected

    def round_times
      %w(start_time end_time).each do |a|
        value = self.send(a)
        self.send("#{a}=", self.class.round_to_nearest_tick(value)) if value
      end
    end

    def self.round_to_nearest_tick(value)
      if value
        sec_in_hour = value.min * 60 + value.sec
        rounded_sec = (sec_in_hour.to_f / MINIMUM_DURATION).round * MINIMUM_DURATION
      
        value - (sec_in_hour - rounded_sec).seconds
      end
    end
  
    def self.nearest_minimum_duration_tick(value)
      (value.to_f / MINIMUM_DURATION).round * MINIMUM_DURATION
    end
  
    def calculate_attribute(attribute)
      if attribute == :end_time
        self.end_time = start_time + duration unless end_time == start_time + duration
      elsif attribute == :duration
        self.duration = end_time - start_time unless duration == end_time - start_time
      else
        raise "unknown attribute: #{attribute}"
      end
    end
    
    def calculate_attributes
      if start_time
        if duration
          calculate_attribute(:end_time)
        elsif end_time
          calculate_attribute(:duration)
        end
      end
    end
  
end
