require 'spec_helper'

describe Project do
  describe :total_time do
    before do
      @user = create(:user)
      @project = create(:project, user: @user)
      
      @now = DateTime.now
      @project.registrations.create(start_time: @now - 5.hours, duration: 1.hour, user: @user)
      @project.registrations.create(start_time: @now + 1.hour, duration: 2.hours, user: @user)
      @project.registrations.create(start_time: @now + 5.hours, duration: 4.hours, user: @user)
    end
    it "accumulates all registration times" do
      @project.total_time.should == 7.hours
    end
    it "accumulates registration times within time spans" do
      @project.total_time(from: @now - 10.days, to: @now - 1.hour).should == 1.hour
      @project.total_time(from: @now - 1.hour, to: @now + 3.hours).should == 2.hours
    end
    it "includes registrations at time span limits" do
      @project.total_time(from: @now + 1.hour, to: @now + 3.hours).should == 2.hours
      @project.total_time(from: @now + 1.hour, to: @now + 9.hours).should == 6.hours
    end
    it "only counts parts of registrations within given time span" do
      @project.total_time(from: @now + 2.hours, to: @now + 4.hours).should == 1.hour
      @project.total_time(from: @now + 2.hours, to: @now + 7.hours).should == 3.hour
    end
  end
end
