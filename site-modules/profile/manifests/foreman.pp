class profile::foreman (
) {

  include ::foreman
  include ::foreman::cli
  include ::foreman::cli::puppet
  include ::foreman::plugin::puppet
  include ::foreman::repo

  Class['foreman::repo']
  -> Class['foreman::install']

  Class['foreman::repo']
  -> Foreman::Plugin <| |>

  class { '::puppet':
    server                => true,
    server_external_nodes => '',
  }

}
