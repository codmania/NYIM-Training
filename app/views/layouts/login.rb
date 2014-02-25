class Views::Layouts::Login < Erector::Widget
  #needs :body
  def out(name)
    name = name.to_sym
    @template_captures ||= {}
    rawtext @template_captures[name] ||= if content_for? name
      content_for name
    else
      text "WARNING: no content for :#{name}"
    end
  end

  def content
    rawtext '<!DOCTYPE html>'
    html do
      head do
        title do
          text 'New York Interactive Media'
        end
        # /Users/tron/Work/Rails/Nyim/design/site/nyim2011.css
        #rawtext stylesheet_link_tag('login.css')
        rawtext stylesheet_link_tag(:all)
        rawtext csrf_meta_tag
      end
      body :class => 'loginbody' do
        widget Erector::Widgets::EnvironmentBadge
        div :id => 'loginbox' do
          out :layout
        end
      end # body
    end # html
  end # def content
end