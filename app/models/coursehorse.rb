class Coursehorse < Payment
  def authorized?(r=self)
    r.submitter.admin?
  end
end
