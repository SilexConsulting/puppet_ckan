class ckan::params {
  $virtual_env_dir   = '/usr/lib/ckan'
  $ckan_config       = '/etc/ckan'
  $ckan_log_root     = '/var/log/ckan'
  $ckan_user         = 'co'
  $ckan_group        = 'co'
  $ckan_root         = '/var/ckan'
  $ckan_db_name      = 'ckan'
  $ckan_db_user      = 'dgu'
  $ckan_db_pass      = 'pass'
  $ckan_who_ini      = "${ckan_root}/who.ini"
  $ckan_log_file     = "${ckan_log_root}/ckan.log"
  $ckan_test_db_user = 'ckan_default'
  $ckan_test_db_name = 'ckan_test'
  $pg_superuser_pass = 'pass'
  $postgis_version   = '9.1'

  case $::osfamily {
    'Debian': {
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
