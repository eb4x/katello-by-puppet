node default { }

node 'foreman.vagrant.local' {
  include "role::admin"
}

node 'katello.vagrant.local' {
  include "role::reposerver"
}
