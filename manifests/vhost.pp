class ckan::vhost (

) {
  apache::vhost { 'ckan':
    port                        => 8000,
    docroot                     => '/var/ckan/',
    logroot                     => $ckan_log_root,
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'wsgi',
    wsgi_import_script          => "${ckan_root}/wsgi_app.py",
    wsgi_import_script_options  =>
      { process-group => 'wsgi', application-group => '%{GLOBAL}' },
    wsgi_process_group          => 'wsgi',
    custom_fragment             => 'WSGIPassAuthorization On',
    wsgi_script_aliases         => { '/data' => '/var/ckan/wsgi_app.py'},
  }
  nginx::resource::vhost { 'ckan':
    proxy_redirect => 'http://ckan/ http://$host/',
    proxy_set_header => ['X-Real-IP  $remote_addr', 'X-Forwarded-For $remote_addr', 'Host $host'],
    proxy => 'http://upstream-ckan',
  }

  nginx::resource::upstream { 'upstream-ckan':
    members => [
      'localhost:8000',
    ],
  }

}