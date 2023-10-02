class profile::foreman (
  String $initial_admin_password = 'changeme',
  String $db_password = 'changeme',
) {

  class { '::foreman::repo':
    repo => '3.7',
  }

  class { '::puppet':
    server                => true,
    server_external_nodes => '',
  }

  class { '::foreman':
    version => 'latest',
    plugin_version => 'latest',
    initial_admin_password => $initial_admin_password,
    db_password => $db_password,
  }

}
