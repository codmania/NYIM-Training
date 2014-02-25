class Comment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :feedback
  
  validates :text, :presence => true
  validates :feedback, :existence => true
  validates :user, :existence => { :conditions => { 'not a teacher or admin' => proc { |u| u.admin? || u.teacher? } } }
  
  validates_each :user, :if => proc { |comment| comment.feedback && comment.user.is_a?(Teacher) } do |record,attr,value|   
    record.errors.add(:user, "(as teacher) can only comment on feedback relating to their class") unless 
    record.feedback.teacher == value
  end
  

end
