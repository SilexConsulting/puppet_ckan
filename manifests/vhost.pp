class ckan::vhost (

) {
  apache::vhost { 'ckan':
    port                        => 80,
    docroot                     => '/var/ckan/',
    logroot                     => $ckan_log_root,
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'wsgi',
    wsgi_import_script          => "${ckan_root}/wsgi_app.py",
    wsgi_import_script_options  =>
      { process-group => 'wsgi', application-group => '%{GLOBAL}' },
    wsgi_process_group          => 'wsgi',
    custom_fragment             => 'WSGIPassAuthorization On',
    wsgi_script_aliases         => { '/' => '/var/ckan/wsgi_app.py'},
  }
}