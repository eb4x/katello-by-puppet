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

}
