class Views::Site::NyimRight < Erector::Widget
  
  def content 
    div :id => 'sidebar', :class => 'sidebar1' do
      rawtext asset('promotion')
      widget ::Views::Site::Promotions
      widget ::Views::Site::Location
    end
  end
end
