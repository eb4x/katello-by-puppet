
```
vagrant up foreman

# Do changes to site-modules
vagrant rsync foreman
vagrant provision foreman --provision-with "puppet apply"

# Testing hiera data; (esp interpolation)
sudo /opt/puppetlabs/bin/puppet lookup foreman_proxy::dhcp_nameservers --hiera_config=hiera.yaml
```
