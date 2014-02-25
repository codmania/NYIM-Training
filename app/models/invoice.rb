class Invoice < Payment
  def authorized?(r=self)
    r.student.is_a?(Student) &&
    r.student.invoiceable ||
    r.submitter.is_a?(Student) &&
    r.submitter.invoiceable
  end

end
