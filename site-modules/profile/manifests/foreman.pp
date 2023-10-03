class profile::foreman (
) {

  include ::foreman
  include ::foreman::repo

  Class['foreman::repo']
  -> Class['foreman::install']

  class { '::puppet':
    server                => true,
    server_external_nodes => '',
  }

}
