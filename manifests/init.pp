# ## Class: autofs ##
#
# Manage AutoFS
#
class autofs(
  $enable           = true,
  $mounttimeout     = 300,
  $umountwait       = undef,
  $browsable        = 'no',
  $mounts           = undef,
  $package_name     = 'autofs',
  $service_name     = 'autofs',
){

  case $::osfamily {
    'Suse', 'RedHat': {
      $config_file  = '/etc/sysconfig/autofs'
    }
    'Debian': {
      $config_file  = '/etc/default/autofs'
    }
    default: {
      fail("autofs supports osfamilies RedHat, Suse and Debian. Detected osfamily is <${::osfamily}>.")
    }
  }

  validate_bool($enable)

  validate_integer($mounttimeout)

  if $umountwait != undef {
    validate_integer($umountwait)
  }

  validate_re($browsable, '^(yes|YES|no|NO)$', "autofs::browsable may be either 'yes', 'YES', 'no' or 'NO' and is set to <${browsable}>")

  if $mounts != undef {
    validate_array($mounts)
  }

  validate_string($package_name)

  validate_string($service_name)

  if $enable == true {

    package { $package_name:
      ensure => present,
    }

    if $config_file != undef {
      file { $config_file:
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $::osfamily ? {
          'Suse'    => template('autofs/suse-sysconfig-autofs.erb'),
          'RedHat'  => template('autofs/redhat-sysconfig-autofs.erb'),
          'Debian'  => template('autofs/debian-default-autofs.erb'),
        },
        require => Package[$package_name],
        notify  => Service[$service_name],
      }
    }

    file { '/etc/auto.master':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('autofs/auto_master.erb'),
      require => Package[$package_name],
      notify  => Service[$service_name],
    }

    service { $service_name:
      ensure     => 'running',
      enable     => true,
      require => Package[$package_name],
    }

  } else {

    service { $service_name:
      ensure     => 'stopped',
      enable     => false,
    }

  }
}
