class Gift < Payment
  def authorized?(r=self)
    r.submitter.admin?
  end
  #belongs_to :card
  #accepts_nested_attributes_for :card, :allow_destroy => true, :reject_if => proc { |attrs| reject_card?(attrs) }

end
