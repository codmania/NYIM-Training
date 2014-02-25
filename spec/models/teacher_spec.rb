require 'spec_helper'

describe Teacher do

  it "should be valid" do
    t = Factory.build :teacher_ben
    t.should be_valid
  end

  it "should set photo properly" do
    t = Factory.create :teacher_ben
    t.photo.path.should == File.join(Rails.root,"public/system/test/photos/#{t.id}/original/BenTestT.jpg")
  end
  
  it "should retrieve upcoming classes" do
    later = Factory.create :excel_class_in_5_days
    earlier = Factory.create :excel_class_in_3_days
    later.teacher.upcoming_classes.all.should == [earlier,later]
  end
  
end
