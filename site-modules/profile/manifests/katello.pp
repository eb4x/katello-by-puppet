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
    # Needs fix in candlepin/manifests/artemis.pp
    Selboolean['candlepin_can_bind_activemq_port']
    -> Service['tomcat']

    package { 'katello-selinux':
      ensure => installed,
      require => Class['katello::repo'],
      before => Service['foreman'],
    }
  }

  include ::foreman_proxy_content

  package { 'foreman-proxy-content':
    ensure => installed,
    require => Class['katello::repo'],
    before => Class['foreman_proxy', 'foreman_proxy_content'],
  }

  Class['katello::repo']
  -> Class['foreman_proxy_content', 'foreman_proxy_content::pub_dir']

  include ::foreman::cli::katello
  include ::foreman::cli::remote_execution
  include ::foreman::plugin::remote_execution
  include ::foreman::plugin::tasks

}
