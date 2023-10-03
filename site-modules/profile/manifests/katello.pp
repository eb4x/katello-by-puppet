class profile::katello (
) {

  include ::katello
  include ::katello::repo

  Class['katello::repo']
  -> Class['certs::install', 'katello']

  include ::pulpcore::repo
  Class['pulpcore::repo']
  -> Package['postgresql-evr']

  include ::candlepin::repo

  if $facts['os']['selinux']['enabled'] {
    selinux::port { 'tomcat_candlepin_port':
      seltype => 'http_port_t',
      protocol => 'tcp',
      port => 23443,
      before => Service['tomcat'],
    }
  }

}
