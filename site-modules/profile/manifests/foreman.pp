class profile::foreman (
) {

  include ::foreman
  include ::foreman::repo

  class { '::puppet':
    server                => true,
    server_external_nodes => '',
  }

}
