class Views::CourseGroups::Corporate < Application::Widget
  def widget_content

    h4 do
      text 'View Pricing on 1-on-1 and Groups'
    end
    table :width => '100%', :align => 'center', :cellpadding => '0', :cellspacing => '0', :class => 'rounded-corners-shadow', :id => 'PT' do
      tr :class => 'rounded-top-corners' do
        th :class => 'center' do
          text '# of'
          br do
            text 'People'
          end
          th :class => 'right' do
            text 'Regular Rate'
          end
          th :class => 'special-right' do
            text 'Special Rate'
          end
        end
        tr :class => 'row1' do
          td :class => 'center' do
            text '1'
          end
          td :class => 'right' do
            text '$125'
          end
          td :class => 'special-right' do
            text '$100'
          end
        end
        tr :class => 'row2' do
          td :class => 'center' do
            text '2'
          end
          td :class => 'right' do
            text '$150'
          end
          td :class => 'special-right' do
            text '$120'
          end
        end
        tr :class => 'row1' do
          td :class => 'center' do
            text '3'
          end
          td :class => 'right' do
            text '$175'
          end
          td :class => 'special-right' do
            text '$140'
          end
        end
        tr :class => 'row2' do
          td :class => 'center' do
            text '4-7'
          end
          td :class => 'right' do
            text '$200'
          end
          td :class => 'special-right' do
            text '$160'
          end
        end
        tr :class => 'row1' do
          td :class => 'center' do
            text '8-12'
          end
          td :class => 'right' do
            text '$275'
          end
          td :class => 'special-right' do
            text '$220'
          end
        end
        tr :class => 'row2' do
          td :class => 'center' do
            text '13-18'
          end
          td :class => 'right' do
            text '$350'
          end
          td :class => 'special-right' do
            text '$280'
          end
        end
        tr :class => 'row1' do
          td :class => 'center' do
            text '18+'
          end
          td :class => 'right' do
            text 'Please contact us for quote'
          end
          td :class => 'special-right' do
            text ''
          end
        end
      end
    end
  end
end
