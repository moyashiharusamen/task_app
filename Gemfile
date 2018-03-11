source 'https://rubygems.org'

ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'activerecord-precounter'
gem 'bcrypt'
gem 'bootstrap-sass'
gem 'coffee-rails', '~> 4.2'
gem 'enum_help'
gem 'email_validator'
gem 'haml-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'kaminari'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'rails-i18n'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'


group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.6.1'
  gem 'factory_bot_rails', '~> 4.8.0'
end

group :test do
  gem 'faker', '~> 1.8.4'
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner', '~> 1.6.1'
  gem 'launchy', '~> 2.4.3'
  gem 'selenium-webdriver', '~> 3.6.0'
end

group :development do
  gem 'bullet'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
