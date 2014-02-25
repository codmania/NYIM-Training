class Views::Layouts::Certificate < Application::Widget
  def content
    rawtext '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
    html :xmlns => 'http://www.w3.org/1999/xhtml', 'xml:lang' => 'en', :lang => 'en' do
      head do
        link :rel => 'icon', :href => '/favicon.ico', :type => 'image/nyim.icon'
        meta 'http-equiv' => 'content-type', :content => 'text/html;charset=UTF-8'
        title do
          rawtext site(:site_name)
        end
        stylesheet_link_tag('certificate')
        if css = css_url('certificate')
          stylesheet_link_tag(css)
        end
      end
      body do
        out :layout
      end
    end
  end
end
