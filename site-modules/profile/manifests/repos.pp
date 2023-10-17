class profile::repos (
) {
  include ::candlepin::repo
  include ::foreman::repo
  include ::katello::repo
  include ::pulpcore::repo
}
