
```
vagrant up foreman

# Do changes to site-modules
vagrant rsync foreman
vagrant provision foreman --provision-with "puppet apply"
```
