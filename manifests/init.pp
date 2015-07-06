# == Defined Type user_group
#
# Create a user and grup with the same name
#
# === Parameters
#
#  ###TODO: add list of parameters here
#
define user_group(
  $ensure           = present,
  $create_group     = true,
  $create_user      = true,
  $gname            = undef,
  $allowdupe        = undef,
  $comment          = undef,
  $gid              = undef,
  $groups           = undef,
  $home             = undef,
  $managehome       = undef,
  $password         = undef,
  $password_max_age = undef,
  $purge_ssh_keys   = undef,
  $shell            = undef,
  $system           = undef,
  $uid              = undef,
  $create_sshdir    = undef,
  $tags             = undef,
  $sshdir_name      = '.ssh',
  $basedir          = '/home',
) {

  include ::user_group::params

  anchor{"${name}_first":}->
  Class['::user_group::params']->
  anchor{"${name}_last":}

  $group_id   = $gid ? { undef => $uid, default => $gid }
  $group_name = $gname ? { undef => $name, default => $gname }

  if str2bool($create_group) == true {
    group { $group_name:
      ensure => $ensure,
      gid    => $group_id,
      system => $system,
      tags   => $tags,
    }
  }

  if str2bool($create_user) == true {

    $nologin_shell = $::user_group::params::nologin_shell
    $real_comment = $comment ? { undef => $name, default => $comment }
    $real_shell = $shell ? { undef => $nologin_shell, default => $shell }

    if $home != undef {
      $real_home = $home
    } else {
      $real_home = $name ? { 'root' => '/root', default => "${basedir}/${name}" }
    }

    $parameters = {
      ensure           => $ensure,
      allowdupe        => $allowdupe,
      comment          => $real_comment,
      gid              => $group_name,
      groups           => $groups,
      home             => $real_home,
      managehome       => $managehome,
      password         => $password,
      password_max_age => $password_max_age,
      shell            => $real_shell,
      system           => $system,
      uid              => $uid,
      tags             => $tags,
    }

    # only use purge_ssh_keys for puppet versions >= 3.6.0
    if versioncmp($::puppetversion, '3.6.0') >= 0 {
      $optional_parameters = { 'purge_ssh_keys' => $purge_ssh_keys }
    }
    else {
      $optional_parameters = {}
      if $purge_ssh_keys != undef {
        fail('purge_ssh_keys is not valid on puppet versions < 3.6.0')
      }
    }

    create_resources(user, {"${name}" => merge($parameters, $optional_parameters)})

    if str2bool($create_sshdir) == true {
      $sshdir = "${real_home}/${sshdir_name}"
      User[$name]->
      file{$sshdir:
        ensure => directory,
        owner  => $name,
        group  => $group_name,
        mode   => '0700',
      }
    }

  }

}
