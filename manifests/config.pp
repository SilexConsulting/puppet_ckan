class ckan::config(
  $virtual_env_dir   = $ckan::params::virtual_env_dir,
  $ckan_user         = $ckan::params::ckan_user,
  $ckan_group        = $ckan::params::ckan_group,
  $ckan_log_root     = $ckan::params::ckan_log_root,
  $ckan_root         = $ckan::params::ckan_root,
  $ckan_db_name      = $ckan::params::ckan_db_name,
  $ckan_db_user      = $ckan::params::ckan_db_user,
  $ckan_db_pass      = $ckan::params::ckan_db_pass,
  $ckan_who_ini      = $ckan::params::ckan_who_ini,
  $ckan_log_file     = $ckan::params::ckan_log_file,
  $ckan_test_db_user = $ckan::params::ckan_test_db_user,
  $ckan_test_db_name = $ckan::params::ckan_test_db_name,
  $pg_superuser_pass = $ckan::params::pg_superuser_pass,
  $postgis_version   = $ckan::params::postgis_version,
  $apache_vhost,
  $apache_port,
  $nginx_vhost,
  $nginx_port,
) {
  # List of python dependencies to be installed with pip
  $pip_pkgs_remote = [
    'setuptools==9.1',
    'Babel==0.9.6',
    'Beaker==1.6.3',
    'ConcurrentLogHandler==0.9.1',
    'Flask==0.8',
    'FormAlchemy==1.4.2',
    'FormEncode==1.2.4',
    'Genshi==0.6',
    'GeoAlchemy==0.7.2',
    'GitPython==0.3.2.RC1',
    'Jinja2==2.7',
    'Mako==0.8.1',
    'MarkupSafe==0.15',
    'OWSLib',
    'Pillow==2.7.0',
    'Pairtree==0.7.1-T',
    'Paste==1.7.5.1',
    'PasteDeploy==1.5.0',
    'PasteScript==1.7.5',
    'PyMollom==0.1',
    'PyYAML==3.10',
    'Pygments==1.6',
    'Pylons==0.9.7',
    'Routes==1.13',
    'SPARQLWrapper==1.6.4',
    'SQLAlchemy==0.7.8',
    'Shapely==1.2.17',
    'Tempita==0.5.1',
    'WebError==0.10.3',
    'WebHelpers==1.3',
    'WebOb==1.0.8',
    'WebTest==1.4.3',
    'Werkzeug==0.8.3',
    'amqplib==1.0.2',
    'anyjson==0.3.3',
    'apachemiddleware==0.1.1',
    'argparse==1.2.1',
    'async==0.6.1',
    'autoneg==0.5',
    'carrot==0.10.1',
    'celery==2.4.2',
    'chardet==2.1.1',
    'cov-core==1.7',
    'coverage==3.7',
    'dateutils==0.6.6',
    'decorator==3.3.2',
    'distribute==0.7.3',
    'fanstatic==0.12',
    'flup==1.0.2',
    'gdata==2.0.18',
    'gitdb==0.5.4',
    'google-api-python-client==1.2',
    'html5lib==0.95',
    'httplib2==0.8',
    'isodate==0.5.0',
    'json-table-schema==0.1',
    'kombu==2.1.3',
    'kombu-sqlalchemy==1.1.0',
    'lxml==3.2.4',
    'messytables==0.10.0',
    'nltk==2.0.4',
    'nose==1.3.0',
    'oauthlib==0.6.3',
    'ofs==0.4.1',
    'openpyxl==1.5.7',
    'pep8==1.4.6',
    'progressbar==2.2',
    'psycopg2==2.4.5',
    'py==1.4.18',
    'pylibmc==1.2.3',
    'pyparsing==2.0.3',
    'pytest==2.4.2',
    'pytest-cov==1.6',
    'python-dateutil==1.5',
    'python-gflags==2.0',
    'python-magic==0.4.3',
    'python-openid==2.2.5',
    'pytz==2012j',
    'pyutilib.component.core==4.6',
    'raven==5.0.0',
    'rdflib==4.1.0',
    'redis==2.9.1',
    'repoze.lru==0.6',
    'repoze.who==1.0.19',
    'repoze.who-friendlyform==1.0.8',
    'repoze.who.plugins.openid==0.5.3',
    'requests==1.1.0',
    'simplejson==2.6.2',
    'six==1.3.0',
    'smmap==0.8.2',
    'solrpy==0.9.5',
    'sqlalchemy-migrate==0.7.2',
    'unicodecsv==0.9.4',
    'urllib3==1.7',
    'vdm==0.11',
    'wsgiref==0.1.2',
    'xlrd==0.9.2',
    'zope.interface==4.0.1',
  ]


  python::virtualenv { $virtual_env_dir:
    ensure        => present,
    owner         => $ckan_user,
    group         => $ckan_group,
  } ->
  exec { "set ${virtual_env_dir} permissions":
    command => "chown -R ${ckan_user}:${ckan_group} ${virtual_env_dir}",
    path          => '/usr/bin:/usr/sbin:/bin',
    user          => 'root',
  } ->
  python::pip { $pip_pkgs_remote:
    virtualenv    => $virtual_env_dir,
    ensure        => present,
    owner         => $ckan_user,
  }


  python::pip { 'ckan':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckan@release-v2.2-dgu',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-dgu':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-dgu@stable',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-os':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-os@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-qa':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-qa@2.0',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-spatial':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-spatial@dgu',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-harvest':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-harvest@2.0',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  } ->
  python::pip { 'ckanext-archiver':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-archiver@master',
    owner         => $ckan_user,
  }

  python::pip { 'ckanext-report':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-report@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }
  python::pip { 'ckanext-ga-report':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-ga-report@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-datapreview':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-datapreview@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-importlib':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/okfn/ckanext-importlib@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-hierarchy':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-hierarchy@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'logreporter':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-hierarchy@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  python::pip { 'ckanext-dgu-local':
    virtualenv    => $virtual_env_dir,
    url           => '-e git+https://github.com/datagovuk/ckanext-dgu-local@master',
    owner         => $ckan_user,
    require       => Python::Virtualenv[$virtual_env_dir],
  }

  file {$ckan_log_file:
    ensure        => file,
    owner         => $ckan_user, #'www-data',
    group         => $ckan_group, #'www-data',
    mode          => 664,
  }

  file { [$ckan_log_root, $ckan_root, "${ckan_root}/data", "${ckan_root}/sstore"]:
    ensure        => directory,
    owner         => $ckan_user, #'www-data',
    group         => $ckan_group, #'www-data',
    mode          => 664,
  }

  define ckan_config_file(
    $path = $title,
    $ckan_db,
    $ckan_site_port = 80,
  ) {
    file { $path:
      ensure      => file,
      content     => template('ckan/ckan.ini.erb'),
      owner         => $ckan_user, #'www-data',
      group         => $ckan_group, #'www-data',
      mode        => 664,
    }
  }

  ckan_config_file { 'ckan_ini_file':
    path          => "${ckan_root}/ckan.ini",
    ckan_db       => $ckan_db_name,
  }

  file { $ckan_who_ini:
    ensure        => file,
    content       => template('ckan/who.ini.erb'),
    owner         => $ckan_user, #'www-data',
    group         => $ckan_group, #'www-data',
    mode          => 664,
  }

  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    ipv4acls                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
    postgres_password          => $pg_superuser_pass,
  }

  postgresql::server::role { $ckan_test_db_user:
    password_hash              => postgresql_password($ckan_test_db_user, $ckan_db_pass),
    login                      => true,
  }
  postgresql::server::role { $ckan_db_user:
    password_hash              => postgresql_password($ckan_db_user, $ckan_db_pass),
    login                      => true,
  }
  postgresql::server::role { 'co':
    password_hash              => postgresql_password('co', $pg_superuser_pass),
    createdb                   => true,
    createrole                 => true,
    login                      => true,
    superuser                  => true,
  }

  file { "/tmp/create_postgis_template.sh":
    ensure                     => file,
    source                     => "puppet:///modules/ckan/create_postgis_template.sh",
    mode                       => 0755,
  }

  exec { 'createdb postgis_template':
    command                    => "/tmp/create_postgis_template.sh ${ckan_test_db_user}",
    unless                     => "psql -l | grep template_postgis",
    path                       => "/usr/bin:/bin",
    user                       => 'co',
    require                    => [
      File['/tmp/create_postgis_template.sh'],
      Package["postgresql-${postgis_version}-postgis"],
      Postgresql::Server::Role['co'],
    ]
  }

  # if only puppetlabs/postgresql allowed me to specify a template...
  exec { "createdb ${ckan_db_name}":
    command                    => "createdb -O ${ckan_db_user} ${ckan_db_name} --template template_postgis",
    unless                     => "psql -l | grep '${ckan_db_name}\s'",
    path                       => '/usr/bin:/bin',
    user                       => 'postgres',
    logoutput                  => true,
    require                    => [
      Exec['createdb postgis_template'],
      Postgresql::Server::Role[$ckan_db_user],
      Class['postgresql::server'],
    ],
  }

  file { '/tmp/create_utf8_template.sh':
    ensure                     => file,
    source                     => 'puppet:///modules/ckan/create_utf8_template.sh',
    mode                       => 0755,
  }

  exec { 'createdb utf8_template':
    command                    => '/tmp/create_utf8_template.sh',
    unless                     => 'psql -l |grep template_utf8',
    path                       => '/usr/bin:/bin',
    user                       => 'co',
    require                    => [
      File['/tmp/create_utf8_template.sh'],
      Postgresql::Server::Role['co'],
    ]
  }

  # The testing process deletes all tables, which doesn't work if there are the Postgis
  # ones there owned by the co user and no deletable. Reconsider this when testing
  # ckanext-spatial.
  exec { "createdb ${ckan_test_db_name}":
    command                    => "createdb -O ${ckan_test_db_user} ${ckan_test_db_name} --template template_utf8",
    unless                     => "psql -l | grep \" ${ckan_test_db_name} \"",
    path                       => '/usr/bin:/bin',
    user                       => 'postgres',
    logoutput                  => true,
    require                    => [
      Exec['createdb utf8_template'],
      Postgresql::Server::Role[$ckan_test_db_user],
      Class['postgresql::server'],
    ],
  }
  
  exec {'paster archiver init':
#    subscribe => Exec['paster db init'],
    command   => "${virtual_env_dir}/bin/paster --plugin=ckanext-archiver archiver init --config=${ckan_root}/ckan.ini",
    path      => '/usr/bin:/bin:/usr/sbin',
    user      => $ckan_user,
    unless    => "sudo -u postgres psql -d ${ckan_db_name} -c \"\\dt\" | grep archival",
    logoutput => 'on_failure',
    require   => [
      Python::Pip['Paste==1.7.5.1'],
      Python::Pip['ckanext-archiver'],
      Python::Virtualenv[$virtual_env_dir],
      Ckan_config_file['ckan_ini_file'],
    ],
  } ->
  exec { 'paster db init':
    subscribe                  => [
      Exec["createdb ${ckan_db_name}"],
      File["${ckan_root}/ckan.ini"],
    ],
    command                    => "${virtual_env_dir}/bin/paster --plugin=ckan db init --config=${ckan_root}/ckan.ini",
    path                       => '/usr/bin:/bin',
    user                       => $ckan_user,
    unless                     => "sudo -u postgres psql -d ${ckan_db_name} -c \"\\dt\" | grep package",
    logoutput                  => true,
    require                    => [
      Python::Pip['psycopg2==2.4.5'],
      Python::Pip['ckanext-harvest'],
      Python::Pip['Paste==1.7.5.1'],
      Python::Virtualenv[$virtual_env_dir],
      Ckan_config_file['ckan_ini_file'],
    ]
  }

  exec { 'paster ga_reports init':
    subscribe                  => Exec['paster db init'],
    cwd                        => "${virtual_env_dir}/src/ckanext-ga-report",
    command                    => "${virtual_env_dir}/bin/paster initdb --config=${ckan_root}/ckan.ini",
    path                       => '/usr/bin:/bin:/usr/sbin',
    user                       => $ckan_user,
    unless                     => "sudo -u postgres psql -d ${ckan_db_name} -c \"\\dt\" | grep ga_url",
    logoutput                  => true,
    require   => [
      Python::Pip['Paste==1.7.5.1', 'ckanext-ga-report'],
      Python::Virtualenv[$virtual_env_dir],
      Ckan_config_file['ckan_ini_file'],
    ],
  }

  exec { 'paster inventory init':
    subscribe => Exec['paster db init'],
    command   => "${virtual_env_dir}/bin/paster --plugin=ckanext-dgu inventory_init --config=${ckan_root}/ckan.ini",
    path      => '/usr/bin:/bin:/usr/sbin',
    user      => $ckan_user, #'www-data',
    unless    => "sudo -u postgres psql -d ${ckan_db_name} -c \"\\dt\" | grep ga_url",
    logoutput => true,
    require   => [
      Python::Pip['Paste==1.7.5.1', 'ckanext-dgu'],
      Python::Virtualenv[$virtual_env_dir],
      Ckan_config_file['ckan_ini_file'],
    ],
  }

  exec {'paster dgu_local init':
    subscribe => Exec['paster db init'],
    command   => "${virtual_env_dir}/bin/paster --plugin=ckanext-dgu-local dgulocal init --config=${ckan_root}/ckan.ini",
    path      => '/usr/bin:/bin:/usr/sbin',
    user      => $ckan_user,
    unless    => "sudo -u postgres psql -d ${ckan_db_name} -c \"\\dt\" | grep organization_extent",
    logoutput => 'on_failure',
    require   => [
      Python::Pip['Paste==1.7.5.1', 'ckanext-dgu-local'],
      Python::Virtualenv[$virtual_env_dir],
      Ckan_config_file['ckan_ini_file'],
    ],
  }
  exec {'paster qa init':
    subscribe => Exec["paster db init"],
    command   => "${virtual_env_dir}/bin/paster --plugin=ckanext-qa qa init --config=${ckan_root}/ckan.ini",
    path      => '/usr/bin:/bin:/usr/sbin',
    user      => $ckan_user,
    unless    => "sudo -u postgres psql -d ${ckan_db_name} -c \"\\dt\" | grep qa",
    logoutput => 'on_failure',
    require   => [
      Python::Pip['Paste==1.7.5.1', 'ckanext-qa'],
      Python::Virtualenv[$virtual_env_dir],
      Ckan_config_file['ckan_ini_file'],
    ],
  }

  class { 'ckan::vhost':
    nginx_vhost => $nginx_vhost,
    nginx_port => $nginx_port,
    apache_vhost => $apache_vhost,
    apache_port => $apache_port,
  }

  file { "${ckan_root}/wsgi_app.py":
    content => template('ckan/wsgi_app.py.erb'),
  }

  # Why use sudo here? There is some weird permissions thing running 'npm
  # install' in puppet as the root user that causes a permissions error:
  #   2 of 3 tests failed:
  # I can replicate this on the command-line when logged in as vagrant and using sudo,
  # but it works if you do 'sudo su' or 'sudo su co' and then do 'sudo npm install'.
  exec { 'npm_deps_dgu':
    command   => 'npm install',
    cwd       => "${virtual_env_dir}/src/ckanext-dgu",
    user      => $ckan_user,
    require   => [
      Python::Pip[$pip_pkgs_remote],
      Class['beluga::developer_tools'],
      Python::Virtualenv[$virtual_env_dir],
    ],
    creates   => '/src/ckanext-dgu/node_modules',
    path      => '/usr/bin:/bin:/usr/sbin:/usr/local/node/node-default/bin',
    logoutput => 'on_failure',
  } ->
  exec {'grunt_dgu':
    command   => 'grunt',
    cwd       => "${virtual_env_dir}/src/ckanext-dgu",
    user      => $ckan_user,
    path      => "/usr/bin:/bin:/usr/sbin:/usr/local/node/node-default/bin",
  }

  vcsrepo { "/vagrant/dgud7/shared_dguk_assets":
    ensure => present,
    provider => git,
    source => 'https://github.com/datagovuk/shared_dguk_assets.git',
    revision => 'master'
  } ->
  exec { 'npm_deps_shared':
    command   => 'npm install',
    cwd       => '/vagrant/dgud7/shared_dguk_assets',
    user      => 'co',
    require   => [
      Python::Pip[$pip_pkgs_remote],
      Class['beluga::developer_tools'],
    ],
    creates   => '/vagrant/dgud7/shared_dguk_assets/node_modules',
    path      => '/usr/bin:/bin:/usr/sbin:/usr/local/node/node-default/bin',
    logoutput => 'on_failure',
  } ->
  exec {'grunt_shared':
    command   => 'grunt',
    cwd       => '/vagrant/dgud7/shared_dguk_assets',
    user      => 'co',
    path      => '/usr/bin:/bin:/usr/sbin:/usr/local/node/node-default/bin',
  }

}
