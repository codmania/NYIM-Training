module ControllerSpecMacros
  
  def test_response(*actions)
    
    options = actions.extract_options!
    user = options[:login]
    user = :user if user.nil?
    
    before :each do
      login user 
    end if user
    
    actions.each do |action|
      describe "GET '#{action}'" do
        it "should be successful" do
          get action
          response.should be_success
        end
      end
    end
    
  end
  

  
end