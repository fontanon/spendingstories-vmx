# TODO: Google Analytics
# Incluir parche SelectPicker https://github.com/pbellon/spendingstories/blob/master/webapp/static/coffee/directives/SelectPicker.coffee
# Rollo monedas

# Default host ip. You should set this on your host machine /etc/hosts file
# WARNING: Make sure this ip is correctly set on Vagrantfile private network param too!
default[:spendingstories][:host_ip] = "192.168.56.101"

# Default hostname for vmx mode. You should set this on your host machine /etc/hosts file.
default[:spendingstories][:host_name] = "spendingstories.dev"
default[:spendingstories][:lang] = "es_ES.utf8"
default[:spendingstories][:lc_all] = "es_ES.utf8"

# Where to download the lastest SpendingStories source code
default[:spendingstories][:gitrepo_uri] = "https://github.com/openkratio/okf-spending-stories"

# SpendingStories config
default[:spendingstories][:sys_home] = "/opt/spendingstories"
default[:spendingstories][:sys_username] = "spendingstories"
default[:spendingstories][:sys_password] = "spendingstories"

# Database settings
default[:spendingstories][:db_engine] = "django.db.backends.mysql" # Add 'postgresql_psycopg2', 'mysql', 'sqlite3'
default[:spendingstories][:db_sqlite_path] = "" # Or path to database file if using sqlite3.

# The following settings are not used with sqlite3:
default[:spendingstories][:db_username] = "spendingstories"
default[:spendingstories][:db_password] = "spendingstories"
default[:spendingstories][:db_name] = "spendingstories"
default[:spendingstories][:db_host]= "localhost" # Empty for localhost through domain sockets or '127.0.0.1' for localhost through TCP.
default[:spendingstories][:db_port] = "" # Set to empty string for default.

# For MySQL installation. Based on chef-mysql_charset recipe https://github.com/geoffreytran/chef-mysql_charset
default[:spendingstories][:db_mysql_encoding]  = "utf8"
default[:spendingstories][:db_mysql_collation] = "utf8_unicode_ci"
