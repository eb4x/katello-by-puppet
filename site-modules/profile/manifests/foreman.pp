class profile::foreman (
  Hash $settings = {},
) {

  include ::foreman
  include ::foreman::cli
  include ::foreman::cli::discovery
  include ::foreman::cli::puppet
  include ::foreman::plugin::discovery
  include ::foreman::plugin::puppet
  include ::foreman::repo

  Class['foreman::repo']
  -> Class['foreman::install']

  Class['foreman::repo']
  -> Foreman::Plugin <| |>

  create_resources('foreman_config_entry', $settings, { require => Class['foreman'] })

  class { '::puppet':
    server                => true,
    server_external_nodes => '',
  }

}
