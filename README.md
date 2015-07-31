# puppet-module-autofs

Manage autofs

===

# Compatibility

This module has been tested to work on the following systems with Puppet v3 (with and without the future parser) and Puppet v4 with Ruby versions 1.8.7, 1.9.3, 2.0.0 and 2.1.0.

  * Debian 7
  * EL5
  * EL6
  * EL7
  * Suse 10
  * Suse 11
  * Ubuntu 12.04

===

# Parameters

enable
------
Boolean value to enable autofs. 

- *Default*: true

mount_timeout
-------
Numeric value to set timeout of mounts in seconds.

- *Default*: 300

umount_wait
----------
Numeric value to try and prevent expire delays when trying to umount from a server
that is not available.

- *Default*: undef

browsable
---------
String value to set browse mode. Valid values are 'yes', 'YES', 'no' and 'NO'.

- *Default*: 'no'

mounts
------
Array of mount paths.

- *Default*: undef

package_name
------------
String to specify the name of the package for autofs.

- *Default*: autofs

service_name
------------
String to specify the name of the service for autofs

- *Default*: autofs

### Sample usage:

<pre>
autofs::enable: false
autofs::mount_timeout: 2400
autofs::browsable: no
autofs::umount_wait: 2
autofs::mounts:
  - +auto.master
  - /home auto.home
  - /somepath yp auto.somepath -nobrowse
</pre>
