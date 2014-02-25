class Profile < ActiveRecord::Base

  belongs_to :teacher

  #validates :bio, :length => { :in => 0..10000 }, :presence => true

  belongs_to :teacher
  
  default :extra_subjects => '', :bio => ''

  def extra_subjects
    (read_attribute(:extra_subjects)||'').split(/,\s+/)
  end

end
