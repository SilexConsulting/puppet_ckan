class ckan(
  $virtual_env_dir = $ckan::params::virtual_env_dir,
  $ckan_user       = $ckan::params::ckan_user,
  $ckan_group      = $ckan::params::ckan_group,
) inherits ckan::params {

  class { 'ckan::install': } ->
  class { 'ckan::config':
    virtual_env_dir => $virtual_env_dir,
    ckan_user       => $ckan_user,
    ckan_group      => $ckan_group,
  } ~>
  Class['uwsgi::service'] ->
  Class['ckan']

}
