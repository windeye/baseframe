# Load the rails application
require File.expand_path('../application', __FILE__)

Haml::Template.options[:format] = :html5
Haml::Template.options[:escape_html] = true
USERNAME_BLACKLIST = ['admin', 'administrator', 'hostmaster', 'info', 'postmaster', 'root', 'ssladmin',
  'ssladministrator', 'sslwebmaster', 'sysadmin', 'webmaster', 'support', 'contact', 'example_user1dsioaioedfhgoiesajdigtoearogjaidofgjo']

require Rails.root.join('config','load_config')
# Initialize the rails application
Testtable::Application.initialize!
