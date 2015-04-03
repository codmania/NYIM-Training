source 'http://rubygems.org'

# only rails < 3.1
#gem 'rack-ssl', :require => 'rack/ssl'

# for mysql client ruby :branch => '0.2.x' needed for rails <=3.0.x
# after 3.1 is stable, use 0.3 series
#gem 'mysql2', :git => 'https://github.com/brianmario/mysql2/', :branch => '0.2.x'
# funnily the mysql adapter needs this?
gem 'rails', '3.1.10'
gem 'mysql2', '>=0.3.12'
gem 'rake', '>=0.9.2'

group :development do
  gem 'capistrano' # Deploy with Capistrano
  gem 'rvm-capistrano', :require => false
  # To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
  # gem 'ruby-debug'
  #gem 'ruby-debug19'
  gem 'debugger'
  gem 'jazz_hands'
  gem 'letter_opener'

  # use vagrant
  #gem 'erubis', "~> 2.7.0"
  #gem 'vagrant', ">=0.8.0"
  #gem 'puppet', ">=2.6.7"
  #gem 'puppet-module'
end

group :test do
  gem 'factory_girl_rails'
  gem 'webrat'
end

group :test, :development do
  #gem 'mongrel', ">= 1.2.0.pre2"
  gem "rspec-rails", "~> 2.4"
  gem 'rails-footnotes', :git => 'git://github.com/josevalim/rails-footnotes.git'#,  :branch => 'rails3'
  gem 'thin'
  #gem 'brakeman'
end

gem "airbrake"

gem "jquery-rails"
#gem 'jrails', :git => 'https://github.com/theworkinggroup/jrails.git'
gem 'jquery-rjs', :git => 'git://github.com/aaronchi/jquery-rjs.git'
# this version for 3.2 compatibility
#gem 'jquery-rjs', :git => 'git://github.com/bikeexchange/jquery-rjs.git'

gem 'rails3-jquery-autocomplete'
gem 'erector', :git => 'git://github.com/bigfix/erector.git', :branch => "rails3"
gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git', :branch => '2.1-stable'

gem 'will_paginate', '~> 3.0.0'
gem "meta_search", :git => 'git://github.com/ernie/meta_search.git'#, :branch => '1-0-stable'
gem "squeel"

gem "cancan"
gem "devise"#, :git => 'git://github.com/plataformatec/devise.git'

gem "activemerchant"#, '1.16'
gem "money"#, :git => 'git://github.com/tobi/money.git'
gem "has_addresses"

gem 'remotipart', "~> 1.0"#, :git => 'git://github.com/formasfunction/remotipart'
gem 'paperclip'

gem 'delayed_job'

gem 'state_machine', :git => 'git://github.com/pluginaweek/state_machine.git'

gem 'acts_as_list'

gem 'date_validator', :git => 'git://github.com/codegram/date_validator.git'

gem 'pdfkit'
gem 'wkhtmltopdf-binary'

gem 'friendly_id', "~> 4.0.0"
