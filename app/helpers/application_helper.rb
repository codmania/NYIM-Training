module ApplicationHelper

  #include Application::Helpers::FullCalendar
  include Application::Helpers::AjaxLinks
  include Application::Helpers::Dropdown

  def class_link(name)
    course_group = CourseGroup.find_by_name(name)
    url          = course_group ? course_group_path(course_group) : '#'
    icon         = course_group ? course_group.short_name.downcase : name.downcase
    link_to url do
      "<img src='/images/icons/#{icon}.png' alt='' width='40' height='40' class='picspace' />#{name}".html_safe
    end
  end

  def description(res)
    res = Asset.asset(res) if res.is_a?(String)
    if res && res.respond_to?(:description_asset_name)
      asset = ::Asset.asset(res.description_asset_name) || ::Asset.asset("#{controller.resource_name}_description")
      if template = asset && asset.read
        controller.render_to_string :inline => template
      elsif res.respond_to?(:url_name)
        "#{res.url_name} #{site(:seo_tag)}"
      end
    else
      site(:seo_tag)
    end
  end

  def keywords(res)
    res = Asset.asset(res) if res.is_a?(String)
    if res && res.respond_to?(:keywords_asset_name)
      asset = ::Asset.asset(res.keywords_asset_name) ||
          ::Asset.asset("#{controller.resource_name}_keywords") ||
          ::Asset.asset("keywords")
      if template = asset && asset.read
        controller.render_to_string :inline => template
      elsif res.respond_to?(:url_name)
        "#{res.url_name} #{site(:seo_tag)}"
      end
    else
      site(:seo_tag)
    end
  end

  def css_url(name)
    asset_url_for(name, 'css')
  end

  def image_url(name)
    asset_url_for(name, 'img')
  end

  def asset_url_for(name, format)
    a = Asset.find_by_name_and_format(name, format) or return nil
    a.asset && a.asset.url
  end

  def formtastic_button(form, label=nil)
    #form.buttons do
    #  form.commit_button(*(args << { :button_html => { 'data-button' => true } }))
    #end
    form.actions do
      options = { :wrapper_html => { :class => '' }, :button_html => { 'data-button' => true }, :as => :button }
      options[:label] = label unless label.blank?
      form.action(:submit, options)
    end
  end

  def money(m)
    "$#{m}".sub(".00", "") if m
  end

  def simple_dropdown(a)
    a.map { |x| [x.to_s.underscore.humanize, x] }
  end

  def boolean_collection
    #[['Yes', 'true'], ['No', 'false']]
    [true, false]
  end

  def yesno(v)
    v ? 'Yes' : 'No'
  end

  def new_action(res)
    res.new_record? ? 'Create' : 'Update'
  end

end
