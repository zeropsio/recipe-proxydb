cat > /etc/proxysql.cnf <<EOF
datadir="/var/lib/proxysql"
errorlog="/var/lib/proxysql/proxysql.log"

admin_variables=
{
	admin_credentials="$PROXYSQL_LOGIN:$PROXYSQL_PASSWORD"
	mysql_ifaces="0.0.0.0:6032"
}

mysql_variables=
{
	have_ssl = true
	use_ssl = 1
	threads = 4
	max_connections = 2048
	default_query_delay = 0
	default_query_timeout = 36000000
	have_compress = true
	poll_timeout = 2000
	interfaces = "0.0.0.0:6033"
	default_schema = "information_schema"
	stacksize = 1048576
	server_version = "5.5.30"
	connect_timeout_server = 3000
	mysql-monitor_enabled = false
	ping_interval_server_msec = 120000
	ping_timeout_server = 500
	commands_stats = true
	sessions_sort = true
	connect_retries_on_failure = 10
}

mysql_servers=
(
	{
		address = "$PROXYSQL_DATABASE_HOSTNAME"
		port = 3306
		hostgroup = 0
	}
)

mysql_users=
(
	{
		username = "$PROXYSQL_DATABASE_USER"
		password = "$PROXYSQL_DATABASE_PASSWORD"
		default_hostgroup = 0
		use_ssl = 1
	}
)
EOF