# 1.- Setup python environment
# include_recipe "locale"
# node[:locale][:lang] = default[:spendingstories][:lang]
# node[:locale][:lc_all] = default[:spendingstories][:lc_all]

user "#{node[:spendingstories][:sys_username]}" do
  comment "#{node[:spendingstories][:sys_username]}"
  system true
  shell "/bin/false"
end

# a. Install python packages
# b. Install virtualenv a tool to isolate your dependencies
include_recipe "python"

# c. Download the project
package('git-core')
git "#{node[:spendingstories][:sys_home]}" do
  repository "#{node[:spendingstories][:gitrepo_uri]}"
  reference "master"
  action :sync
end

# d. Create the virtualenv folder for this project
# e. Activate your new virtualenv
# Every python dependencies will be installed in this folder to keep your system's environment clean.
python_virtualenv "#{node[:spendingstories][:sys_home]}/venv" do
  owner "#{node[:spendingstories][:sys_username]}"
  group "#{node[:spendingstories][:sys_password]}"
  options "--no-site-packages --distribute --prompt=SpendingStories"
  action :create
end

# 2. Install dependencies
# a. Install python modules required
python_pip "django" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "1.5.1"
end

python_pip "djangorestframework" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "2.3.5"
end

python_pip "django-filter" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "0.6.0"
end

python_pip "django-compressor" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "1.3.0"
end

python_pip "git+https://github.com/vied12/datapackage.git" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
end

python_pip "django-model-utils" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "1.4.0"
end

python_pip "markdown" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "2.3.1"
end

python_pip "loremipsum" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "1.0.2"
end

python_pip "requests" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "1.2.3"
end

python_pip "south" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "0.8.1"
end

python_pip "BeautifulSoup" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "3.2.1"
end

python_pip "dj-static" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "0.0.5"
end

python_pip "django-wysiwyg-redactor" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "0.3.6"
end

package("libpq-dev")
python_pip "psycopg2" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "2.5.1"
end

python_pip "dj-database-url" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "0.2.2"
end

python_pip "gunicorn" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "0.17.2"
end

python_pip "django-storages" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "1.1.8"
end

python_pip "boto" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
  version "2.9.9"
end

# b. Install compilers for Less and CoffeeScript
package("python-software-properties")
package("g++")
package("make")

apt_repository "node.js" do
  uri "http://ppa.launchpad.net/chris-lea/node.js/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C7917B12"
end

package("nodejs")

# and then install them
execute "npm install" do
  cwd "#{node[:spendingstories][:sys_home]}/venv"
  command "npm install"
end

# 3. Set up the database

# a. Configure the file webapp/settings.py
template "#{node[:spendingstories][:sys_home]}/webapp/settings.py" do
  source "settings.py.erb"
  mode 00644
  owner "root"
  group "root"
  variables(
    :db_engine => node['spendingstories']['db_engine'],
    :db_name => node['spendingstories']['db_name'],
    :db_username => node['spendingstories']['db_username'],
    :db_password => node['spendingstories']['db_password'],
    :db_host => node['spendingstories']['db_host'],
    :db_port => node['spendingstories']['db_port']
  )
end

# Example with MySQL
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "database::mysql"

# For MySQL, you will need to install mysql-python, like that:
package("libmysqlclient-dev")

python_pip "mysql-python" do
  virtualenv "#{node[:spendingstories][:sys_home]}/venv"
end

# and create the database
# (character setup based on chef-mysql_charset recipe https://github.com/geoffreytran/chef-mysql_charset)
# WARNING: Hardcoded path. Better using
template "#{node[:mysql][:confd_dir]}/charset.cnf" do
  source "charset.cnf.erb"

  variables(
    :encoding  => node[:spendingstories][:db_mysql_encoding],
    :collation => node[:spendingstories][:db_mysql_collation]
  )
end

mysql_database "#{node[:spendingstories][:db_name]}" do
  connection ({:host => "#{node[:spendingstories][:db_host]}", :username => 'root', :password => node['mysql']['server_root_password']})
  action [:create]
end

mysql_database_user "#{node[:spendingstories][:db_username]}" do
  connection ({:host => "#{node[:spendingstories][:db_host]}", :username => 'root', :password => node['mysql']['server_root_password']})
  password      "#{node[:spendingstories][:db_password]}"
  database_name "#{node[:spendingstories][:db_name]}"
  host          "#{node[:spendingstories][:db_host]}"
  action        [:grant]
end

# 4. Run server

# a. For development
# execute "npm install" do
#   cwd "#{node[:spendingstories][:sys_home]}"
#   command "python manage.py runserver
# end

# b. For production
include_recipe("apache2")
package("libapache2-mod-wsgi")
include_recipe("apache2::mod_wsgi")

web_app 'spendingstories' do
  template "site_conf.erb"
  docroot node['spendingstories']['sys_home']
  # server_name node['spendingstories']['host_name']
end
