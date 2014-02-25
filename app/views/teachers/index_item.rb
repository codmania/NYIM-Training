class Views::Teachers::IndexItem < Application::Widget

  needs :teacher, :name => true
  def widget_content
    link_to teacher_path(teacher) do
      span do

        div :id => dom_id(teacher,:index_item), :class => 'box' do
          h2 teacher.name if name
          img :src => teacher.photo.url, :alt => teacher.name,  :width => '155', :height => '155', :class => 'fltl-left-rounded-corners-shadow'
          ul do
            teacher.extra_subjects.each do |subject|
              # li { link_to subject, subject }
              li subject
            end
          end
          br :style => "clear:both;"
        end
      end
    end
  end
end
