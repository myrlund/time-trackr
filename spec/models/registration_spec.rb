require 'spec_helper'

describe Registration do
  before do
    @registration = create(:registration)
    @now = DateTime.now
  end
  
  it "adjusts end_time when altering duration" do
    @registration.start_time = @now - 2.hours
    
    @registration.duration = 2.hours
    @registration.end_time.should == @now
    
    @registration.duration += 1.hour
    @registration.end_time.should == @now + 1.hour
  end
  
  it "adjusts duration when altering end_time" do
    @registration.start_time = @now - 2.hours
    
    @registration.end_time = @now
    @registration.duration.should == 2.hours
    
    @registration.end_time = @now + 4.hours
    @registration.duration.should == 6.hours
  end
  
  it "adjusts end_time when altering start_time" do
    @registration.start_time = @now - 2.hours
    @registration.end_time = @now
    
    @registration.start_time += 2.hours
    @registration.end_time.should == @now + 2.hours
    @registration.duration.should == 2.hours
    
    @registration.start_time -= 5.hours
    @registration.end_time.should == @now - 3.hours
    @registration.duration.should == 2.hours
  end
  
  it "rounds times when saving" do
    round = DateTime.now.beginning_of_day + 14.hours
    
    @registration.start_time = round + 4.minutes
    @registration.save
    @registration.start_time.should == round
    
    @registration.end_time = round + 40.minutes
    @registration.save
    @registration.end_time.should == round + 45.minutes
  end
  
end
