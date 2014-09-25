class ckan::config(
  $virtual_env,
  $owner,
  $group,
){

  class { 'python':
    version    => 'system',
    virtualenv => true,
    pip => true,
    dev => true,  #required for pip to install dependencies
  }

  $python_libs = [
    'libxslt1-dev',
    'libpq-dev',
    'python-psycopg2',
    'python-pastescript',
    'libmemcached-dev'
  ]

  class { "uwsgi": }

  # List of python dependencies to be installed with pip
  $pip_pkgs_remote = [
    'amqplib==1.0.2',
    'anyjson==0.3.3',
    'apachemiddleware==0.1.1',
    'argparse==1.2.1',
    'autoneg==0.5',
    'Babel==0.9.6',
    'Beaker==1.6.3',
    'carrot==0.10.1',
    'celery==2.4.2',
    'chardet==2.1.1',
    'ConcurrentLogHandler==0.9.1',
    'cov-core==1.7',
    'coverage==3.7',
    'dateutils==0.6.6',
    'decorator==3.3.2',
    'distribute==0.7.3',
    'fanstatic==0.12',
    'Flask==0.8',
    'flup==1.0.2',
    'FormAlchemy==1.4.2',
    'FormEncode==1.2.4',
    'gdata==2.0.18',
    'Genshi==0.6',
    'GeoAlchemy==0.7.2',
    'google-api-python-client==1.2',
    'httplib2==0.8',
    'Jinja2==2.7',
    'json-table-schema==0.1',
    'kombu==2.1.3',
    'kombu-sqlalchemy==1.1.0',
    'lxml==3.2.4',
    'Mako==0.8.1',
    'MarkupSafe==0.15',
    'messytables==0.10.0',
    'nltk==2.0.4',
    'nose==1.3.0',
    'ofs==0.4.1',
    'openpyxl==1.5.7',
    'Pairtree==0.7.1-T',
    'Paste==1.7.5.1',
    'PasteDeploy==1.5.0',
    'PasteScript==1.7.5',
    'pep8==1.4.6',
    #'PIL==1.1.7',
    'psycopg2==2.4.5',
    'py==1.4.18',
    'Pygments==1.6',
    'pylibmc==1.2.3',
    'Pylons==0.9.7',
    'PyMollom==0.1',
    'pytest==2.4.2',
    'pytest-cov==1.6',
    'python-dateutil==1.5',
    'python-gflags==2.0',
    'python-magic==0.4.3',
    'python-openid==2.2.5',
    'pytz==2012j',
    'pyutilib.component.core==4.6',
    'PyYAML==3.10',
    'redis==2.9.1',
    'repoze.lru==0.6',
    'repoze.who==1.0.19',
    'repoze.who-friendlyform==1.0.8',
    'repoze.who.plugins.openid==0.5.3',
    'requests==1.1.0',
    'Routes==1.13',
    'Shapely==1.2.17',
    'simplejson==2.6.2',
    'setuptools==1.1.6',
    'six==1.3.0',
    'solrpy==0.9.5',
    'SQLAlchemy==0.7.8',
    'sqlalchemy-migrate==0.7.2',
    'Tempita==0.5.1',
    'unicodecsv==0.9.4',
    'urllib3==1.7',
    'vdm==0.11',
    'WebError==0.10.3',
    'WebHelpers==1.3',
    'WebOb==1.0.8',
    'WebTest==1.4.3',
    'Werkzeug==0.8.3',
    'wsgiref==0.1.2',
    'xlrd==0.9.2',
    'zope.interface==4.0.1',
  ]


  package  {$python_libs:
    ensure => installed
  } ->

  python::virtualenv { $virtual_env:
    ensure       => present,
    #requirements => "${virtual_env}/requirements.txt",
    owner        => $owner,
    group        => $group,
  } ->

  python::pip { $pip_pkgs_remote:
    virtualenv    => $virtual_env,
  } ->

  python::pip { 'ckan':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckan@release-v2.2-dgu',
  } ->

  python::pip { 'ckanext-dgu':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-dgu@stable',
  } ->

  python::pip { 'ckanext-os':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-os@master',
  } ->

  python::pip { 'ckanext-qa':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-qa@2.0',
  } ->

  python::pip { 'ckanext-spatial':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-spatial@dgu',
  } ->

  python::pip { 'ckanext-harvest':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-harvest@2.0',
  } ->

  python::pip { 'ckanext-archiver':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-archiver@master',
  } ->

  python::pip { 'ckanext-ga-report':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-ga-report@master',
  } ->

  python::pip { 'ckanext-datapreview':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-datapreview@master',
  } ->

  python::pip { 'ckanext-importlib':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/okfn/ckanext-importlib@master',
  } ->

  python::pip { 'ckanext-hierarchy':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-hierarchy@master',
  } ->

  python::pip { 'logreporter':
    virtualenv    => $virtual_env,
    url           => '-e git+https://github.com/datagovuk/ckanext-hierarchy@master',
  }

}
