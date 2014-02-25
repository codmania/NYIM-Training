module MailMockHelper
  def mock_mail(*mails)
    @mail = mock_model('FakeMail')
    @mail.stub!(:deliver).and_return(@mail)
    mails.each { |mail| Mailers::UserMailer.stub!(mail).and_return(@mail) }
    @mail.should_receive(:deliver).and_return(@mail)
  end

end