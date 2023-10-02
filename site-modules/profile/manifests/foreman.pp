class profile::foreman (
) {

  class { '::foreman::repo':
    repo => '3.7',
  }

}
