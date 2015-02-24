class ckan(
  $virtual_env_dir = $ckan::params::virtual_env_dir,
  $ckan_user       = $ckan::params::ckan_user,
  $ckan_group      = $ckan::params::ckan_group,
  $apache_vhost = $ckan::params::apache_vhost,
  $apache_port = $ckan::params::apache_port,
  $nginx_vhost = $ckan::params::nginx_vhost,
  $nginx_port = $ckan::params::nginx_port,

) inherits ckan::params {

  class { 'ckan::install': } ->
  class { 'ckan::config':
    virtual_env_dir => $virtual_env_dir,
    ckan_user       => $ckan_user,
    ckan_group      => $ckan_group,
    nginx_vhost     => $nginx_vhost,
    nginx_port      => $nginx_port,
    apache_vhost    => $apache_vhost,
    apache_port     => $apache_port,
  } ~>
  Class['uwsgi::service'] ->
  Class['ckan']

}
