class ckan::vhost (
  $apache_vhost,
  $apache_port,
  $nginx_vhost,
  $nginx_port,

) {
  apache::vhost { $apache_vhost:
    port                        => $apache_port,
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
  nginx::resource::location { 'ckan':
    ensure   => present,
    location => '/data',
    vhost    => $nginx_vhost,
    proxy_redirect => "http://$apache_vhost/ http://\$host:$nginx_port/",
    proxy_set_header => ['X-Real-IP  $remote_addr', 'X-Forwarded-For $remote_addr', "Host $apache_vhost"],
    proxy => 'http://upstream-ckan',
  }

  nginx::resource::upstream { 'upstream-ckan':
    members => [
      "$apache_vhost:$apache_port",
    ],
  }

}