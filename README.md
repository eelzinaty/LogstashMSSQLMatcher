# Logstash Plugin - MSSQLMatcher
This filter add new field from sql server to the output by matching input field from sql data.

## How to use
filter {
	mssqlmatcher {
		 target=> "uid"
		 target_column => "target_column_name"
		 source=> "user"
		 source_column => "source_column_name"
		 jdbc_driver_library => "path/to/jdbc/sqljdbc41.jar"
		jdbc_driver_class => "com.microsoft.sqlserver.jdbc.SQLServerDriver"
		jdbc_connection_string => "jdbc:sqlserver://servername:port;instanceName=instancename;databaseName=dbname;"
		jdbc_user => "dbuser"
		jdbc_password => "dbpassword"
		statement => "select target_column_name, source_column_name from table_name"
	}
}