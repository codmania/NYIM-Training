class Views::Teachers::Index < Application::Widget
  def widget_content
    h1 'Trainers'

    left_indexes = (0..(resource.length-1)/2).map{ |a| a*2 }
    right_indexes = left_indexes.map { |a| a+1 }
    last = right_indexes.last
    right_indexes.pop if last && resource[last].nil?

    div :id => 'content_left' do
      left_indexes.each do |t|
        widget Views::Teachers::IndexItem, :teacher => resource[t]
        br :class => 'item_spacer'
      end
    end
    div :id => 'content_right' do
      right_indexes.each do |t|
        widget Views::Teachers::IndexItem, :teacher => resource[t]
        br :class => 'item_spacer'
      end
    end
  end
end