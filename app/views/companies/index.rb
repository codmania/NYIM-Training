class Views::Companies::Index < Application::Widgets::List
  #needs :display_options => nil, :search_options => Signup.search
  def widget_content
    h1 'Partial Client List'
    p do
      text "We have had the pleasure to work with many of the world's most influential companies along with 'up and coming' companies and individuals. We feel comfortable training everyone from  head executives to beginners."
    end
    rawtext will_paginate resource
    self.info = nil
    self.pagination = nil
    div :class => 'box_striped', :id => 'clientlist' do
      self.info = false
      p do
        super
      end
    end

  end

  def item(c)
    p do
      if c.display_with_url
        link_to c.name, c.url, :popup => true, :remote => false
      else
        text c.name
      end
    end
  end

end