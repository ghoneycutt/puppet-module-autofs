# autofs #
===

Automounter for NFS.

This module will first check that the required package for autofs is present and installed. 
Then it will check that the file 'auto.master' exists in the path '/etc/auto.master'. 
If the file 'auto.master' changes, the service 'autofs' is notifed and restarted.
The service 'autofs' is dependant on that the service 'idmapd_service' is already running.
