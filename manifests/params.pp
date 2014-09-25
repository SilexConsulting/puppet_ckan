class ckan::params(){
  case $::osfamily {
    'Debian': {
      $virtual_env_dir                    = '/usr/local/lib/ckan'
      $ckan_user                          = 'ckan'
      $ckan_group                         = 'ckan'
      $ckan_config                        = '/etc/ckan'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
