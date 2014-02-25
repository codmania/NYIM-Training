class Views::Site::NyimMain < Erector::Widget
  
  def content 
    div :id => 'main' do
      rawtext '<!-- TemplateBeginEditable name="MainContent" -->'
      h1 do
        text 'The highest rated corporate & group computer training in new york'
      end
      h2 do
        text 'Why we are your best choice:'
      end
      ul do
        li :class => 'rounded-corners-shadow' do
          text 'Certified Trainers, minimum of 10 yrs experience'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Since 1998'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Lifetime online forum support'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Top Notch feedback and client list'
          br
        end
      end
      h2 do
        text 'Group classes:'
        br
      end
      ul do
        li :class => 'rounded-corners-shadow' do
          text 'LIFETIME Unlimited retakes'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Micro Classes (3-6 people)'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Hands on (with fast computers)'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Hours of after class video training'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Classes don\'t get cancelled'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Materials constantly updated'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Free Coffee, Tea, Chocolate, water'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Comfortable, Convenient location'
        end
        li :class => 'rounded-corners-shadow' do
          text '75% off all future versions'
        end
        li :class => 'rounded-corners-shadow' do
          text 'Shortcut Efficiency driven'
        end
      end
      rawtext '<!-- TemplateEndEditable -->'
      rawtext '<!-- end #main -->'
    end
  end
end
