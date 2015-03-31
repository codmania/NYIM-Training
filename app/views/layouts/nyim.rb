class Views::Layouts::Nyim < Erector::Widget

  include Application::Widgets::Extensions

  def content
    rawtext '<!DOCTYPE HTML>'
    html do
      head do
        title do
          text controller.document_title
        end
        meta :name => "Description", :content => description(resource)
        meta :name => "Keywords", :content => keywords(resource)
        meta :name => "google-site-verification", :content => "gYgrSxeDwD-_K0OmU1vTps7qD0cVySOoOp79bc47Ass"
        stylesheet_link_tag(:all)
        if nyimcss = css_url('nyim')
          stylesheet_link_tag(nyimcss)
        end
        javascript_include_tag(
          #'http://code.jquery.com/jquery-1.6.2.js',
          'marquee',
          'jquery.min',
          'jquery-ui.min',
          'jquery.livequery.min',
          #'jquery.ui.datetime.min',
          #'jMenu.jquery',
          'jquery_ujs',
          'jquery-ui-timepicker-addon',
          'fullcalendar.min',
          'jquery.form',
          'jquery.iframe-transport',
          'jquery.remotipart',
          'jquery.easyListSplitter',
          'autocomplete-rails',
          '//cdn.ckeditor.com/4.4.7/standard/ckeditor.js',
          'application',
        'ajax_history')
        rawtext csrf_meta_tags unless response.cache_control[:public]
      end
      body do
        div :id => 'dimmer', :style => 'display:none'
        div :id => 'loginbox', :style => 'display:none'
        div :id => 'spinner', :style => 'display:none' do
          text 'loading...'
        end
        div :class => 'container' do
          widget Views::Site::NyimHeader
          div :id => main_container_dom, :class => 'content' do
            out :layout
          end
          if user_signed_in?
            widget Views::Site::UserPanel
          else
            widget Views::Site::NyimRight
          end
          widget Views::Site::NyimFooter

        end #container
        rawtext asset('bottom bar')
      end # body
    end # html
  end # def content
end
