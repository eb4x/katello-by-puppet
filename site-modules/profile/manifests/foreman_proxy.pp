class profile::foreman_proxy (
) {

  include ::foreman::repo

  include ::foreman_proxy
  include ::foreman_proxy::plugin::discovery

  Class['foreman::repo']
  -> Class['foreman_proxy::install']

}
