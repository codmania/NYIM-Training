class Mailers::UserMailer < ActionMailer::Base

  helper :application

  ADMIN_EMAIL = proc { }
  default :sender      => proc { Site.site(:admin_email) },
    :reply_to    => proc { Site.site(:admin_email) },
    :bcc         => proc { "#{Site.site(:admin_email)}, nyim.devel@gmail.com" },
    :parts_order => ['text/html', 'text/plain']
  #default_url_options[:host] ||= "training-nyc.com"

  def layout_assets
    @assets ||= Asset.assets :template
    return @assets unless @assets.empty?
    images = ['shine.png', 'ribbon.png', 'footerbg.png', 'footerbg_light.png', 'chocolate_coffee_water_100.jpg',
              'nyimlogo.png', 'spacer.png', 'mail.png', 'facebook.gif', 'twitter.gif']

    images.each_with_index do |image, i|
      file = File.new(Rails.root.join('public/design/email_templates/layout', image))
      Asset.create!(:name => :template, :format => 'img', :index => i, :asset => file)
    end
    html_layout = File.new(Rails.root.join('public/design/email_templates/layout/email_template.html.erb'))
    Asset.create!(:name => :template, :format => 'html', :asset => html_layout)
    @assets = Asset.assets :template
  end

  MAILS = [
    :course_ends,
    :activation_request,
    :activation,
    :waiting_list_confirmation,
    :seat_available,
    :certificate,
    :invoice,
    :course_reminder,
    :course_confirmation,
    :course_cancelation,
    :course_cancelation_admin,
    :certificates_to_be_mailed,
    :trainer_class_reminder
  ]

  PART_FORMATS       = { :html => :inline, :text => :inline }
  ATTACHMENT_FORMATS = [:pdf, :img]
  FORMATS            = PART_FORMATS.keys + ATTACHMENT_FORMATS
  FORMAT_NAMES       = FORMATS.map(&:to_s)

  def test_email(options={ }, *args)
    @user = options[:user] || Admin.first
    email = @user.email
    @url  = default_url_options[:host]
    mail(:to => email, :subject => "Test") do
      render :layout => false
    end
  end

  def template_assets(name)
    assets = Asset.assets(name)
    if assets.empty?
      html_template = File.new(Rails.root.join("public/design/email_templates/#{name}.html.erb"))
      assets[:html] = Asset.create!(:name => name, :format => 'html', :asset => html_template)
      text_template = File.new(Rails.root.join("public/design/email_templates/#{name}.txt.erb"))
      assets[:text] = Asset.create!(:name => name, :format => 'text', :asset => text_template)
    end
    assets
  end

  def asset(name, options={ }, assigns={ })

    assets            = template_assets(name)
    options[:subject] ||= self.class.subject(name, assigns)
    options[:to]      ||= (assigns[:user] || assigns[:student]).ifnil?('viktor.tron@gmail.com', &:email)

    # :img1 => file, :img2 => file
    assets.each do |format, asset|
      attachments.inline[asset.asset_file_name] = asset.read || "" unless PART_FORMATS[format]
    end
    layout_assets.each do |format, asset|
      attachments.inline[asset.asset_file_name] = asset.read || "" unless PART_FORMATS[format]
    end
    @html_email_template = layout_assets[:html].ifnil? { |x| x.asset.path }
    @text_email_template = layout_assets[:text].ifnil? { |x| x.asset.path }

    # calls hook to add arbitrary attachment
    create_attachments(name, assigns)

    #Rails.logger.warn assets.inspect
    #puts assets.inspect
    # part formats, complains if no both html and txt
    mail(options) do |part|
      PART_FORMATS.each do |format, render_option|
        part.send(format) do
          asset          = assets[format]
          render_options = { :locals => assigns, :layout => 'email', :handlers => [:erb] }
          #render_options[render_option] = asset.asset.path if asset
          render_options[render_option] = asset.read
          render render_options
        end
      end
    end

  end



  def self.subject(name, assigns)
    case name.to_sym
    when :course_ends then
      "[NYIM] Your class '#{assigns[:signup].name}' has ended, please give us feedback and get your certificate"
    when :activation_request then
      '[NYIM] Please activate your new account'
    when :activation then
      '[NYIM] Your account has been activated!'
    when :waiting_list_confirmation then
      "[NYIM] You have been added to the waiting list for our course #{assigns[:signup].name}"
    when :seat_available then
      "[NYIM] Free seats on our course #{assigns[:signup].name}"
    when :certificate then
      "[NYIM] Your certificate for is ready"
    when :invoice then
      "[NYIM] Invoice"
    when :course_reminder then
      "[NYIM] Your class '#{assigns[:signup].name}' is starting on #{assigns[:signup].starts_at.to_date.to_s}"
    when :course_confirmation then
      "[NYIM] You signed up to our class '#{assigns[:signup].name}'"
    when :course_cancelation then
      "[NYIM] You canceled your class '#{assigns[:signup].name}'"
    when :course_cancelation_admin then
      "[NYIM] refund notification: #{assigns[:student].full_name} canceled class '#{assigns[:signup].name}'"
    when :certificates_to_be_mailed then
      "[NYIM] Certificates to be mailed"
    when :trainer_class_reminder then
      "[NYIM] #{assigns[:course].full_name}"
    end
  end

  protected

  def create_attachments(name, assigns)
    hook = "#{name}_attachments"
    send hook, assigns if respond_to? hook
  end

  def certificate_attachments(assigns)
    # create pdf certificate
    css = File.join(Rails.root, 'public/stylesheets/certificate.css')
    html = Views::Signups::DiscloseCertificate.new(:resource => assigns[:signup], :pdf => true).to_html
    kit  = PDFKit.new(html)
    kit.stylesheets << css
    attachments['certificate.pdf'] = kit.to_pdf
  end

end
