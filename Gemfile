source 'http://rubygems.org'
gem 'rack',          '~>1.3.0'
gem 'rake',          '~>0.9.2.1'
gem 'sinatra'
gem 'mustache',      '~>0.99.4'
gem "SystemTimer",   "~>1.2.3", :platforms => [:mri_18]
gem 'yajl-ruby'
gem 'redis'
gem 'sinatra_auth_github', '~>0.8.2'
gem 'sprockets'
gem 'sass',          '~>3.1'
gem 'coffee-script'
gem 'pusher'
gem 'foreman'
gem 'unicorn'

if RUBY_PLATFORM.downcase.include?("darwin")
  gem 'rubyosa19', :git => 'git://github.com/pbosetti/rubyosa.git'
end

group :test do
  gem 'rack-test'
  gem 'mocha',        '~>0.11.1'
end

group :development do
  gem 'shotgun'
end
