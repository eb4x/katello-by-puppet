class role::reposerver {
  include profile::foreman
  include profile::foreman_proxy
  include profile::katello
}
