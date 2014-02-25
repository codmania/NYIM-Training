class Views::Site::SearchAndDisplayForm < Application::Widget

  needs :display_options => nil, :search_options => nil, :display_columns => nil, :url => nil

  def widget_content
    style = "accordion #{dom_class(controller.resource_class,:accordion)}"

    form_tag url || polymorphic_path(controller.resource_class, :action => :list),
             :method => :get, :class => "formtastic" do
      div :class => style do
        h3 { link_to "display options", '#', :remote => false }
        div :class => 'fixed_accordion_section' do
          semantic_fields_for display_options do |f|
            div do
              f.inputs :class => 'multi-column-list' do
                f.input :options, :label => '', :required => false, :as => :check_boxes,
                        :collection      => display_columns.map(&:to_s)
              end
            end
          end
        end

        h3 { link_to "search options", '#', :remote => false }
        div :class => 'fixed_accordion_section' do
          #logger.warn self.class
          semantic_fields_for search_options do |f|
            call_block(f)
          end # search options
        end # fixed accordion section

      end # accordion

      h2 do
        submit_tag 'Show', 'data-button' => true
        text '   '
        submit_tag 'Export', 'data-button' => true, :disabled => true
      end
      javascript_tag <<EOF
        $(".multi-column-list ol").easyListSplitter({
          colNumber: 4,
          direction: 'vertical'
        });
EOF
    end #form
  end #widget

end
