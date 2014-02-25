class Cheque < Payment
  def authorized?(r=self)
    r.submitter.admin?
  end

end
