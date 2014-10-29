class ckan::install(){
  include dgu_solr
  include uwsgi
  include apache
  include apache::mod::wsgi

  if ! defined(Package['libxslt1-dev'])       { package { 'libxslt1-dev':       ensure => present } }
  if ! defined(Package['libpq-dev'])          { package { 'libpq-dev':          ensure => present } }
  if ! defined(Package['python-psycopg2'])    { package { 'python-psycopg2':    ensure => present } }
  if ! defined(Package['python-pastescript']) { package { 'python-pastescript': ensure => present } }
  if ! defined(Package['libmemcached-dev'])   { package { 'libmemcached-dev':   ensure => present } }

}
