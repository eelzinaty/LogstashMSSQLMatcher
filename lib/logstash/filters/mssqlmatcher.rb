# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
#require "set"
require "time"
require "date"
require "java"
require "sequel"
require "sequel/adapters/jdbc"

#
# This filter add new field from sql server to the output by matching input field from sql data.
#
# The config looks like this:
#
#     filter {
#       mssqlmatcher {
#			target=> "uid"
#			target_column => "target_column_name"
#			source=> "user"
#			source_column => "source_column_name"
#			jdbc_driver_library => "path/to/jdbc/sqljdbc41.jar"
#			jdbc_driver_class => "com.microsoft.sqlserver.jdbc.SQLServerDriver"
#			jdbc_connection_string => "jdbc:sqlserver://servername:port;instanceName=instancename;databaseName=dbname;"
#			jdbc_user => "dbuser"
#			jdbc_password => "dbpassword"
#			statement => "select target_column_name, source_column_name from table_name"
#		}
#     }
#
# The `field` is the field you want added to the event.
class LogStash::Filters::MSSQLMatcher < LogStash::Filters::Base
  #include LogStash::PluginMixins::MSSQLMatcher
  config_name "mssqlmatcher"
  
  config :target, :validate => :string, :required => false, :default => "uid"
  config :target_column, :validate => :string, :required => true
  config :source, :validate => :string, :required => true
  config :source_column, :validate => :string, :required => true
  # here, ":target_id" is a named parameter. You can configure named parameters
  # with the `parameters` setting.
  config :statement, :validate => :string
  # Hash of query parameter, for example `{ "target_id" => "321" }`
  #config :parameters, :validate => :hash, :default => {}

	# JDBC driver library path to third party driver library. In case of multiple libraries being
	# required you can pass them separated by a comma.
	#
	# If not provided, Plugin will look for the driver class in the Logstash Java classpath.
	config :jdbc_driver_library, :validate => :string

	# JDBC driver class to load, for exmaple, "org.apache.derby.jdbc.ClientDriver"
	# NB per https://github.com/logstash-plugins/logstash-input-jdbc/issues/43 if you are using
	# the Oracle JDBC driver (ojdbc6.jar) the correct `jdbc_driver_class` is `"Java::oracle.jdbc.driver.OracleDriver"`
	config :jdbc_driver_class, :validate => :string, :required => true

	# JDBC connection string
	config :jdbc_connection_string, :validate => :string, :required => true

	# JDBC user
	config :jdbc_user, :validate => :string, :required => true

	# JDBC password
	config :jdbc_password, :validate => :string, :required => true

  
  public
  def register
    #prepare_jdbc_connection
  end # def register
  
  public
  def initialize(config = {})
    super
	require @jdbc_driver_library
    #@threadsafe = false

    @ids = []
	Sequel::JDBC.load_driver(@jdbc_driver_class)
	@DB = Sequel.connect(@jdbc_connection_string+"user="+@jdbc_user+";password="+@jdbc_password)
	
    @DB[@statement].each do |row|
		@ids << row
	end
	
	#puts @ids
  end # def filter
  public
  def filter(event)
    return unless filter?(event)
	#puts event[@source]
    if f = @ids.find {|f| f[@source_column.to_sym]  == event[@source] }
    	event[@target] = f[@target_column.to_sym]
    else
		event[@target] = 'N/A'
    end
    filter_matched(event)
  end # def filter
  
end # class LogStash::Filters::MSSQLMatcher