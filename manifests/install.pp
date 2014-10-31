class ckan::install(){
  include beluga::apache_frontend_server
  include beluga::java
  include dgu_solr
  package { 'rabbitmq-server':
    ensure => present,
  }

  package { 'postgresql-9.1-postgis':
    ensure                     => present,
    require                    => Class['postgresql::server'],
  }

  class { 'python':
    dev                       => true,  # required for pip to install dependencies
    pip                       => true,
    version                   => 'system',
    virtualenv                => true,
  } ->
  class {'uwsgi':
  }

  if ! defined(Package['libxslt1-dev'])       { package { 'libxslt1-dev':       ensure => present } }
  if ! defined(Package['libpq-dev'])          { package { 'libpq-dev':          ensure => present } }
  if ! defined(Package['python-psycopg2'])    { package { 'python-psycopg2':    ensure => present } }
  if ! defined(Package['python-pastescript']) { package { 'python-pastescript': ensure => present } }
  if ! defined(Package['libmemcached-dev'])   { package { 'libmemcached-dev':   ensure => present } }

}
