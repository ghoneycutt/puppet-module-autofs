# ## Class: autofs ##
#
# Manage AutoFS
#
class autofs {

  include nfs

  package { 'autofs':
    ensure => present,
  }

  file { 'auto.master':
    ensure  => file,
    path    => '/etc/auto.master',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['autofs'],
    notify  => Service['autofs'],
  }

  service { 'autofs':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    before     => Service['idmapd_service'],
  }
}
