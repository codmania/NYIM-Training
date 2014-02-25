#https://github.com/jdpace/PDFKit
# config/initializers/pdfkit.rb
PDFKit.configure do |config|
  #config.wkhtmltopdf = 'wkhtmltopdf'
  config.default_options = {
    :page_size => 'Letter',
    :print_media_type => true
  }
end
# in application.rb(Rails3) or environment.rb(Rails2)
#require 'pdfkit'
#config.middleware.use PDFKit::Middleware
#sudo apt-get install wkthmltopdf
# or
#gem 'pdfkit'
#gem 'wkhtmltopdf-binary'

#kit = PDFKit.new(html, :page_size => 'Letter')
#kit.stylesheets << '/path/to/css/file'
#
## Git an inline PDF
#pdf = kit.to_pdf
#
## Save the PDF to a file
#file = kit.to_file('/path/to/save/pdf')