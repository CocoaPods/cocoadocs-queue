source 'https://rubygems.org'
ruby '2.2.0'

# gem 'nap', :git => 'https://github.com/alloy/nap.git', :branch => 'error'
gem 'pg'
gem 'dm-core', require: true
# gem 'dm-do-adapter', require: true
gem 'dm-postgres-adapter', require: true
gem 'flounder'

group :queue do
  gem 'nap'
end

group :web do
  gem 'sinatra'
end

group :development, :production do
  gem 'foreman'
  gem 'thin'
end

group :test do
  gem 'bacon'
  gem 'mocha-on-bacon'
  gem 'nokogiri'
  gem 'prettybacon'
  gem 'rack-test'
  gem 'rubocop'
end