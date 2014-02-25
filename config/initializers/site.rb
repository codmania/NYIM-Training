module SiteExtension
  def site(a)
    Site.get_option(a)
  end
end

class ActiveRecord::Base
  include SiteExtension
  extend SiteExtension
end

class ActiveRecord::Observer
  include SiteExtension
  extend SiteExtension
end

class ActionMailer::Base
  include SiteExtension
  extend SiteExtension
end

class ActionView::Base
  include SiteExtension
  extend SiteExtension
end

class ActionController::Base
  include SiteExtension
  extend SiteExtension
  helper_method :site
end

