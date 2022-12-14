# ProxyDB Zerops's recipe

Demonstration of using ProxySQL to access MariaDB in Zerops.

## Basic facts

* ProxySQL is set to require SSL connections only.

* To access ProxySQL from outside the Internet, it's necessary to set the public access through IPv4 or IPv6 addresses for the `proxysql:6033` port. See the example below.

![ProxySQL](./docs/Public-Access-Through-IP-Addresses.png "Public access through IP addresses")

* To access the MariaDB database from Google DataStudio fill in the connection form. Because of the SSL connection, you have to attach `proxy-ca.pem` certificate from the ProxySQL instance. You can find it in the ProxySQL data directory `/var/lib/proxysql/`.

![Google DataStudio](./docs/Google-DataStudio-MySQL-DataSource.png "MySQL data source")

* The ProxySQL configuration is created through `zerops.yml` build pipe YAML and the `proxysql-cnf.sh` script.

* The included simple Node.js application has no direct relation to the described ProxySQL solution.

* A new password for admin access to the ProxySQL server is automatically generated by the Zerops import pre-processor (enabled by the first line in the import YAML script `#yamlPreprocessor=on`). See the documentation for the [generateRandomString](/documentation/export-import/import-script-pre-processing.html#generaterandomstring) import function. The generated password will be stored in the environment variable **PROXYSQL_PASSWORD**.

## Zerops import script to instantiate the demonstration

```yml
#yamlPreprocessor=on
project:
  name: ProxySqlAccess
services:
  - hostname: db
    type: mariadb@10.4
    mode: NON_HA
    priority: 1
  - hostname: proxysql
    type: nodejs@16
    envVariables:
      PROXYSQL_DATABASE_HOSTNAME: ${db_hostname}
      PROXYSQL_DATABASE_PASSWORD: ${db_password}
      PROXYSQL_DATABASE_USER: ${db_user}
      PROXYSQL_LOGIN: proxysql
      PROXYSQL_PASSWORD: <@generateRandomString(<12>)>
    ports:
      - port: 6032
      - port: 6033
      - port: 3000
        httpSupport: true
    minContainers: 1
    maxContainers: 1
    buildFromGit: https://github.com/zeropsio/recipe-proxydb@main
```
