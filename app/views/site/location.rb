class Views::Site::Location < Application::Widget
  def widget_content
    div :class => 'location' do
      div :class => 'rounded-corners-shadow', :id => 'location'
      h3 '-'
      h4 :class => 'caption' do
        text 'Heart of Union Square'
      end
      p do
        text '1 Union Square West and 14ths St.'
      end
      p do
        text '[Right off 4,5,6,R,Q,W,N,L,F,M trains]'
      end
    end
  end
end
