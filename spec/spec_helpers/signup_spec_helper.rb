module SignupSpecHelper
  def should_allow_events!(signup,*events)
    (signup.status_events - events).should be_empty
    (events - signup.status_events).should be_empty
  end

  def sign_up_with(signup_factory,*options)
    signup = Factory.build signup_factory, *options
    signup.allow_double_booking = true
    signup.save!
    signup.check_out.should be_true
    mock_mail :course_confirmation
    signup.succeed.should be_true
    signup
  end


end

