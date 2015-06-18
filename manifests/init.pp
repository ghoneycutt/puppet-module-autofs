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
){

  case $::osfamily {
    'Suse', 'RedHat': {
      $package_name = 'autofs'
      $service_name = 'autofs'
      $config_file  = '/etc/sysconfig/autofs'
    }
    'Debian': {
      $package_name = 'autofs'
      $service_name = 'autofs'
      $config_file  = '/etc/default/autofs'
    }
    default: {
      fail("cron supports osfamilies RedHat, Suse and Debian. Detected osfamily is <${::osfamily}>.")
    }
  }

  case type($enable) {
    'string': {
      validate_re($enable, '^(true|false)$', "autofs::enable may be either 'true' or 'false' and is set to <${enable}>")
      $enable_real = str2bool($enable)
    }
    'boolean': {
      $enable_real = $enable
    }
    default: {
      fail('autofs::enable type must be true or false.')
    }
  }

  if is_integer($mounttimeout) == false {
    fail("autofs::mounttimeout is set to <${mounttimeout}>. It should be an integer.")
  }

  validate_re($browsable, '^(yes|YES|no|NO)$', "autofs::browsable may be either 'yes', 'YES', 'no' or 'NO' and is set to <${browsable}>")

  if $mounts != undef {
    validate_array($mounts)
  }

  if $enable_real == true {

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
      require => Package['autofs'],
    }

  } else {

    service { $service_name:
      ensure     => 'stopped',
      enable     => false,
    }

  }
}
