module AssetsHelper
  def asset_form_content(form, w)
    form.semantic_errors
    form.inputs do
      form.input :name, :required => true #, :input_html => { :readonly => !form.object.name.blank? }
      form.input :asset, :required => true
      form.input :format, :required => true, :as => :select, :collection => Asset::FORMATS
      form.input :index
    end


    unless form.object.format == 'img'
      asset_content = resource.read
      begin
        asset_content && asset_content.gsub!(/\t/, "   ")
        #: invalid byte sequence in UTF-8
        formtastic_button(form)
        form.object.content = asset_content || ''
        w.h2 'Content'
        hint = 'Edits in the text box are ignored if you upload a file'
        w.text hint
        w.div :class => 'asset_view_box' do
          form.inputs do
            form.input :content, :as => :text, :input_html => { :size => "80x80" }, :hint => hint
          end
        end

      rescue ArgumentError => exc
        w.text "Malformed template: #{exc}"
      end
    end
    formtastic_button(form)
    w.rawtext "<script type=\"text/javascript\"> if('#asset_content'){
                CKEDITOR.replace('asset_content', {
                  filebrowserImageUploadUrl: '/uploads'}
                );
                $('.asset_view_box label.label').remove();
              } </script>"
  end

  def asset(resource, fallback = nil)
    asset = ::Asset.asset(resource) || fallback && ::Asset.asset(fallback)
    out   = ''
    begin
      if template = asset && asset.read
        out << controller.render_to_string(:inline => template)
      elsif admin?
        out << "Missing asset '#{resource}'. "
        out << link_to("Click here to upload.",
                       asset ? edit_asset_path(asset) : new_asset_path(:asset => { :name => resource }))
        if fallback
          out << "Missing default asset '#{fallback}'. "
          out << link_to("Click here to upload.",
                         asset ? edit_asset_path(asset) : new_asset_path(:asset => { :name => fallback }))
        end
      else
        out << "Information currently being updated."
      end
    rescue ArgumentError => exc
      if admin?
        out << "Malformed template: #{exc}. "
        out << link_to("Click here to correct.", edit_asset_path(asset))
      else
        out << "Information currently being updated."
      end
    end
    out.html_safe
  end

  def asset_link(resource, text=nil)
    text ||= resource.humanize.downcase
    link_to text, display_asset_path(resource) rescue ''
  end

end
