class profile::foreman_proxy (
) {

  include ::foreman::repo

  include ::foreman_proxy

  Class['foreman::repo']
  -> Class['foreman_proxy::install']

}
