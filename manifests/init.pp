# == Class: autofs
#
# Manage AutoFS
#
class autofs(
  $enable        = true,
  $mount_timeout = 300,
  $umount_wait   = undef,
  $browsable     = 'no',
  $mounts        = undef,
  $package_name  = 'autofs',
  $service_name  = 'autofs',
) {

  case $::osfamily {
    'RedHat': {
      $config_file   = '/etc/sysconfig/autofs'
      $template_name = 'autofs/redhat-sysconfig-autofs.erb'
    }
    'Suse': {
      $config_file   = '/etc/sysconfig/autofs'
      $template_name = 'autofs/suse-sysconfig-autofs.erb'
    }
    'Debian': {
      $config_file   = '/etc/default/autofs'
      $template_name = 'autofs/debian-default-autofs.erb'
    }
    default: {
      fail("autofs supports osfamilies RedHat, Suse and Debian. Detected osfamily is <${::osfamily}>.")
    }
  }

  validate_bool($enable)

  validate_numeric($mount_timeout, undef, 1)

  if $umount_wait != undef {
    validate_numeric($umount_wait, undef, 1)
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
        content => template($template_name),
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
  }

  service { $service_name:
    ensure => $enable,
    enable => $enable,
  }
}
