class ckan::vhost (
  $ckan_log_root = $ckan::params::ckan_log_root,
) {
  apache::vhost { 'ckan':
    # WSGIDaemonProcess singlethreaded
    wsgi_daemon_process => 'singlethreaded',
    # WSGIProcessGroup singlethreaded
    wsgi_process_group  => 'singlethreaded',
    # WSGIScriptAlias / ${ckan_root}/wsgi_app.py
    wsgi_script_aliases => { '/' => "${ckan_root}/wsgi_app.py", },
    # WSGIPassAuthorization On
    custom_fragment     => 'WSGIPassAuthorization On',
    port                => 80,
    log_level           => 'warn',
    docroot             => '/var/www/ckan',
    logroot             => $ckan_log_root,
  }
}