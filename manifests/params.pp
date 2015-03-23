# == Class user_group::params
#
# This class is meant to be called from user_group
# It sets variables according to platform
#
class user_group::params{

  case $::osfamily {
    'Solaris': {
      $nologin_shell = '/bin/false'
    }
    default: {
      $nologin_shell = '/sbin/nologin'
    }
  }

}
