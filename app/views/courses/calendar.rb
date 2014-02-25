class Views::Courses::Calendar < Application::Widget
  def widget_content

    table :border => '0', :cellpadding => '0', :cellspacing => '5', :class => 'rounded-corners-shadow', :id => 'calendar' do
      tr do
        td :colspan => '7', :class => 'button' do
          rawtext '&laquo;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;June&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&raquo;'
        end
      end

      tr :class => 'days' do
        td do
          text 'Su'
        end
        td do
          text 'M'
        end
        td do
          text 'T'
        end
        td do
          text 'W'
        end
        td do
          text 'Th'
        end
        td do
          text 'F'
        end
        td do
          text 'S'
        end
      end
      tr do
        td :class => 'off' do
          rawtext '&nbsp;'
        end
        td :class => 'off' do
          rawtext '&nbsp;'
        end
        td :class => 'off' do
          rawtext '&nbsp;'
        end
        td :class => 'on' do
          text '1'
        end
        td :class => 'on' do
          text '2'
        end
        td :class => 'on' do
          text '3'
        end
        td :class => 'on' do
          text '4'
        end
      end
      tr do
        td :class => 'on' do
          text '5'
        end
        td :class => 'on' do
          text '6'
        end
        td :class => 'on' do
          text '7'
        end
        td :class => 'on' do
          text '8'
        end
        td :class => 'on' do
          text '9'
        end
        td :class => 'on' do
          text '10'
        end
        td :class => 'on' do
          text '11'
        end
      end
      tr do
        td :class => 'on' do
          text '12'
        end
        td :class => 'on' do
          text '13'
        end
        td :class => 'on' do
          text '14'
        end
        td :class => 'on' do
          text '15'
        end
        td :class => 'on' do
          text '16'
        end
        td :class => 'on' do
          text '17'
        end
        td :class => 'on' do
          text '18'
        end
      end
      tr do
        td :class => 'on' do
          text '19'
        end
        td :class => 'on' do
          text '20'
        end
        td :class => 'on' do
          text '21'
        end
        td :class => 'on' do
          text '22'
        end
        td :class => 'on' do
          text '23'
        end
        td :class => 'on' do
          text '24'
        end
        td :class => 'on' do
          text '25'
        end
      end
      tr do
        td :class => 'on' do
          text '26'
        end
        td :class => 'on' do
          text '27'
        end
        td :class => 'on' do
          text '28'
        end
        td :class => 'on' do
          text '29'
        end
        td :class => 'on' do
          text '30'
        end
        td :class => 'off' do
          rawtext '&nbsp;'
        end
        td :class => 'off' do
          rawtext '&nbsp;'
        end
      end
    end
  end
end