class ckan(
  $virtual_env_dir = 'UNSET',
  $owner           = $::ckan::params::ckan_owner,
  $group           = $::ckan::params::ckan_group,
) inherits ckan::params {

  $virtual_env = $virtual_env_dir ? {
    'UNSET'   => $::ckan::params::virtual_env_dir,
    default   => $virtual_env_dir,
  }

  class { 'ckan::install': } ->
  class { 'ckan::config':
    virtual_env => $virtual_env,
    owner => $owner,
    group => $group,
  } ~>
  Class['uwsgi::service'] ->
  Class['ckan']

}
