# Plugins
  plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
  plugin 'hoptoad_notifier', :git => "git://github.com/thoughtbot/hoptoad_notifier.git"
  plugin 'haml', :git => "git://github.com/nex3/haml.git"
  plugin 'factory_girl', :git => "git://github.com/thoughtbot/factory_girl.git"
  plugin 'resource_controller', :git => "git://github.com/giraffesoft/resource_controller.git"
  plugin 'paperclip', :git => "git://github.com/thoughtbot/paperclip.git"

# Delete unnecessary files
  run "rm README"
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm public/robots.txt"
  run "rm -f public/javascripts/*"
 
# JQuery
  run "curl -L http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js > public/javascripts/jquery.js"  

#====================
# APP
#====================    

file 'app/views/layouts/_flashes.html.erb', 
%q{<div id="flash">
  <% flash.each do |key, value| -%>
    <div id="flash_<%= key %>"><%=h value %></div>
  <% end -%>
</div>
}

#TODO: make sure jquery works
file 'app/views/layouts/application.html.erb', 
%q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <title><%= PROJECT_NAME.humanize %></title>
    <%= stylesheet_link_tag 'screen', :media => 'all', :cache => true %>
    <%= javascript_include_tag :defaults, :cache => true %>
  </head>
  <body class="<%= body_class %>">
    <%= render :partial => 'layouts/flashes' -%>
    <%= yield %>
  </body>
</html>
}


# ====================
# ENVIRONMENT
# ====================
 
#TODO: cucumber gem not being unpacked
#      add zentest to gems
file 'config/environment.rb', 
%q{
 
#Change this:
PROJECT_NAME          = "app_template"
AWS_ACCESS_KEY        = "123"
AWS_SECRET_ACCESS_KEY = "123"
HOAPTOAD_KEY          = "123"
STAGING_SERVER_IP     = "111.111.111.111"
PRODUCTION_SERVER_IP  = "111.111.111.111"

 
throw "The project's name in environment.rb is blank" if PROJECT_NAME.empty?
throw "Project name (#{PROJECT_NAME}) must_be_like_this" unless PROJECT_NAME =~ /^[a-z_]*$/
 
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
 
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
 
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
 
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.
 
  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
 
  # Specify gems that this application depends on.
    config.gem 'rspec', 
               :lib      => false, 
               :version  => ">=1.2.2"
    
    config.gem 'rspec-rails', 
               :lib      => false, 
               :version  => ">=1.2.2"
    
    config.gem 'webrat', 
               :lib      => false, 
               :version  => ">=0.4.4"
    
    config.gem 'cucumber', 
               :lib      => false, 
               :version  => ">=0.2.3"
    
    config.gem 'chronic'
    
    config.gem 'hpricot', 
               :source   => 'http://code.whytheluckystiff.net'
    
    config.gem 'tpope-pickler',
                :lib     => 'pickler',
                :source  => 'http://gems.github.com'
                 
    #config.gem 'sqlite3-ruby', 
    #           :lib     => 'sqlite3',
    #           :version => '>=1.2.4'
    
    config.gem 'aws-s3', 
               :lib      => 'aws/s3'
               
    config.gem 'RedCloth',
               :lib      => 'redcloth', 
               :version  => '~> 3.0.4'
    
    config.gem 'mislav-will_paginate', 
               :lib      => 'will_paginate', 
               :source   => 'http://gems.github.com', 
               :version  => '~> 2.3.5'
    
    config.gem 'mocha', 
               :version  => '>= 0.9.2'
    
    config.gem 'quietbacktrace', 
               :version  => '>= 0.1.1'
    
   config.gem  'thoughtbot-factory_girl',
               :lib    => false,
               :source => "http://gems.github.com"


  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # Add the vendor/gems/*/lib directories to the LOAD_PATH
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
 
  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
 
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'
 
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  SESSION_KEY = "CHANGESESSION" 
  config.action_controller.session = {
    :session_key => "_#{PROJECT_NAME}_session",
    :secret      => SESSION_KEY
  }
 
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store
 
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
 
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end
}


# ====================
# DATABASE
# ====================

file 'config/database.yml', 
%q{
development:
  adapter: sqlite3
  database: <%= PROJECT_NAME %>_development
  
test:
  adapter: sqlite3
  database: db/<%= PROJECT_NAME %>_test

  
staging:
  adapter: sqlite3
  database: db/<%= PROJECT_NAME %>_staging

  
production:
  adapter: sqlite3
  database: db/<%= PROJECT_NAME %>__production
}
 
#====================
# CAPISTRANO
#====================
 
capify!

file 'Capfile', 
%q{
  load 'deploy' if respond_to?(:namespace) # cap2 differentiator
  Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
  load 'config/deploy'
}
 

file 'config/deploy.rb', 
%q{
  require File.expand_path(File.dirname(__FILE__) + '/environment')
  set :stages, %w(staging production)
  set :default_stage, 'staging'
  require 'capistrano/ext/multistage'
   
  default_run_options[:pty] = true 
  
  set :keep_releases, 10
  
  set :scm, :git
  set :repository,  "git@github.com:voodoorai2000/#{PROJECT_NAME}.git"
  set :branch, "master"
  set :deploy_via, :checkout
  
  set :user, "deploy"
  set :port, "32200"  
  set :runner, "deploy"
  
  desc "create symbolic links for files outside of version control"
  task :create_symbolic_links, :roles => :app do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/initializers/hoptoad.rb #{release_path}/config/initializers/hoptoad.rb" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/db/schema.rb #{release_path}/db/schema.rb" 
  end
  
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
    
  after "deploy", ["create_symbolic_links", "restart"]
}
 
file 'config/deploy/staging.rb', 
%q{
 set :rails_env, 'staging'
  
 role :app, "#{STAGING_SERVER_IP}"  
 role :web, "#{STAGING_SERVER_IP}"  
 role :db,  "#{STAGING_SERVER_IP}", :primary => true
 
 set :deploy_to, "/var/www/apps/#{PROJECT_NAME}"
}
 
file 'config/deploy/production.rb', 
%q{
 set :rails_env, 'production'
 role :app, "#{PRODUCTION_SERVER_IP}"  
 role :web, "#{PRODUCTION_SERVER_IP}"  
 role :db,  "#{PRODUCTION_SERVER_IP}", :primary => true
 
 set :deploy_to, "/var/www/apps/#{PROJECT_NAME}"
 
 desc "create symbolic link to backup_fu.yml"
 task :create_symbolic_links_for_backups, :roles => :app do
   run "ln -nfs #{deploy_to}/#{shared_dir}/config/backup_fu.yml #{release_path}/config/backup_fu.yml" 
 end
 
 after "deploy:update_code", "create_symbolic_links_for_backups"
}


#====================
# HOAPTOAD
#====================

initializer 'hoptoad.rb', 
%q{
  HoptoadNotifier.configure do |config|
    config.api_key = "HOAPTOAD_KEY"
  end
}

#====================
# BACKUP_FU
#====================

file 'config/backup_fu.yml',
%q{
  production:
    app_name: <%= PROJECT_NAME %>
    s3_bucket: <%= PROJECT_NAME %>_backups
    aws_access_key_id: <%= AWS_ACCESS_KEY %>
    aws_secret_access_key: <%= AWS_SECRET_ACCESS_KEY %>
    verbose: true
    static_paths: "public/static public/users"
}

#====================
# CUCUMBER
#====================

generate("cucumber")

#TODO: Add cucumber autotest and growler
file 'cucumber.yml',
%q{
  webrat:   --require features/step_definitions --require features/support/webrat_env.rb   -l es  --tags webrat    --format pretty features
  selenium: --require features/step_definitions --require features/support/selenium_env.rb -l es  --tags selenium  --format pretty features
  autotest: --require features/step_definitions --require features/support/webrat_env.rb   -l es  --tags webrat    --format pretty features --color
}

#TODO: include factory_girl
file 'features/support/env.rb',
%q{
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  require 'cucumber/rails/world'
  require 'cucumber/formatter/unicode'
  Cucumber::Rails.bypass_rescue

  require 'webrat'

  require 'cucumber/rails/rspec'
  require 'webrat/core/matchers'
  
  require 'spec/mocks'
  require 'ruby-debug'
  require 'chronic'
  require 'factory_girl'

  def empty_database
    connection = ActiveRecord::Base.connection
    connection.tables.each do |table|
      connection.execute "DELETE FROM #{table}" 
    end
  end
}

file 'features/support/webrat_env.rb',
%q{
require File.expand_path(File.dirname(__FILE__) + '/env.rb')
require File.expand_path(File.dirname(__FILE__) + '/webrat_helpers.rb')
require 'webrat/rails'

Cucumber::Rails.use_transactional_fixtures

Webrat.configure do |config|
  config.mode = :rails
end

After do
  empty_database
end
}

file 'features/support/selenium_env.rb',
%q{
  require File.expand_path(File.dirname(__FILE__) + '/env.rb')
  require 'webrat/selenium'
  require 'selenium'
  require File.expand_path(File.dirname(__FILE__) + '/selenium_helpers.rb')


  Webrat.configure do |config|
    config.mode = :selenium
    config.application_environment = :test
  end

  After do
    Email.delete_all
    empty_database
  end
}

file 'features/support/webrat_helpers.rb',
%q{
module Webrat
  class RailsSession < Session
     def request_path
       integration_session.request.path
     end
     
     def wait_for_ajax; end

     def wait_for_page_to_load(timeout = 20000); end
     
     def method_missing(m, *args)  
       if m == :selenium
         raise "Hey, looks like you are trying to run a selenium scenario with the non-selenium configuration\
                please add '@selenium' to the line before this scenario"
       else
         super
       end
     end
     
  end
  
end

Webrat::Methods.delegate_to_session :request_path, :wait_for_ajax, :wait_for_page_to_load
}

#TODO: make sure we need all these.
file 'features/support/selenium_helpers.rb',
%q{
  class Webrat::SeleniumSession
    def wait_for_ajax
      selenium.wait_for_condition('!selenium.browserbot.getCurrentWindow().jQuery || selenium.browserbot.getCurrentWindow().jQuery.active == 0', 20000)
    end

    def wait_for_page_to_load(timeout = 20000)
      selenium.wait_for_page_to_load(timeout)
      wait_for_ajax
    end

    def request_path
      selenium.get_location.gsub("http://localhost:3001", "")
    end

    def selenium_window_eval(code)
      selenium.get_eval("selenium.browserbot.getCurrentWindow().#{code}")
    end
  end

  Webrat::Methods.delegate_to_session :request_path, :wait_for_ajax, :wait_for_page_to_load, :selenium_window_eval

  module Webrat

    def self.start_selenium_server 
      nil
    end

    def self.stop_selenium_server
      nil
    end

  end
}

#====================
# CRUISECONTROL
#====================

file 'lib/tasks/cruise.rake',
%q{
  desc 'Continuous build tasks'
  task :cruise do
    CruiseControl::invoke_rake_task 'db:migrate'
    CruiseControl::invoke_rake_task 'cruise:test:all'
  end
  
  namespace :cruise do
    namespace :test do
      
      desc "Run all features with the required servers" 
      task :all do
        Rake::Task['spec'].invoke
        with_servers do
          Rake::Task['features:all'].invoke 
        end
      end
      
    end
  end
}

#====================
# TASKS
#====================

file 'lib/testing_servers.rb',
%q{
  def with_servers
    xserver_pid = run_command("startx -- `which Xvfb` :1 -screen 0 1024x768x24")
    selenium_pid = run_command("sh -c 'DISPLAY=:1 selenium -browserSessionReuse'")
    yield
  ensure 
    system("killall xterm")
    require 'selenium'
    Selenium::SeleniumServer.new.stop
  end
  
  def run_command(cmd)
    fork do
      [STDOUT,STDERR].each {|f| f.reopen '/dev/null', 'w' }
      exec cmd
    end
  end
}

file 'lib/tasks/custom.rake',
%q{
namespace :test do
  desc "Run all specs & features"
  task :all => [ "spec", "features:all" ]
end

namespace :features do
  desc "Run all features"
  task :all => [ :webrat, :selenium ]
  
  desc "Run webrat features"
  task :webrat do
    sh "script/cucumber features --profile webrat"
  end
  
  desc "Run selenium features"
  task :selenium do
    sh "script/cucumber features --profile selenium"
  end

end
}

#====================
# PIVOTAL TRACKER (PICKLER)
#====================


#TODO: try and automate with this
#echo "api_token: ..."  > ~/.tracker.yml
#  echo "project_id: ..." > ~/my/app/features/tracker.yml
#  echo "ssl: [true|false]" >> ~/my/app/features/tracker.yml
file 'features/tracker.yml',
%q{
  api_token:  PIVOTAL_API_TOKEN
  project_id: PIVOTAL_PROJECT_ID
  ssl: true
}

# Install Gems
rake('gems:install', :sudo => true)
rake('gems:build', :sudo => true)
rake('gems:unpack', :sudo => true)
#rake('rails:freeze:gems', :sudo => true)

#Generate
generate('authenticated', 'user session')
generate('rspec')

# Migrate
rake('db:migrate')

# Make sure testing is in place
rake('test:all')

#Git
git :init

run "echo 'TODO add readme content' > README"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore restart.txt"
run "cp config/database.yml config/example_database.yml"

file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

git :add => ".", :commit => "-m 'initial commit'"
