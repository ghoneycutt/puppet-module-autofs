# puppet-module-autofs

Manage autofs

===

# Compatibility

This module has been tested to work on the following systems with Puppet v3 and Ruby versions 1.8.7, 1.9.3 and 2.0.0.

  * RedHat
  * Suse
  * Ubuntu
  * Debian

===

# Parameters

enable
------
Boolean value to enable autofs. 

- *Default*: true

mounttimeout
-------
Numeric value to set timeout of mounts in seconds.

- *Default*: 300

browsable
---------
String value to set browse mode. Valid values are 'yes', 'YES', 'no' and 'NO'.

- *Default*: 'no'

mounts
------
Array value to set mount paths.

- *Default*: undef

### Sample usage:

autofs::enable: true
autofs::timeout: 2400
autofs::browsable: 'no'
autofs::mounts:
  - +auto.master
  - /home auto.home
  - /somepath auto.somepath -nobrowse
