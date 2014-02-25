module SpecUtils
  def check(s)
    s.valid?
    puts s.inspect
    puts s.errors.inspect
  end

  def site(*a)
    Site.site(*a)
  end
end
