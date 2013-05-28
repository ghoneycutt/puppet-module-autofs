# autofs #
===

Automounter for NFS.

This module will first check that the required package for autofs is present and installed. 
Then it ensures /etc/auto.master is a file.
If the file 'auto.master' changes, the service 'autofs' is notifed and restarted.
The service 'autofs' depends on the 'idmapd_service' service.
