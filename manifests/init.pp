# == Defined Type user_group
#
# Create a user and grup with the same name
#
# === Parameters
#
#  ###TODO: add list of parameters here
#
define user_group(
  $ensure         = present,
  $create_group   = true,
  $create_user    = true,
  $gname          = undef,
  $allowdupe      = undef,
  $comment        = undef,
  $gid            = undef,
  $groups         = undef,
  $home           = undef,
  $managehome     = undef,
  $password       = undef,
  $purge_ssh_keys = undef,
  $shell          = undef,
  $system         = undef,
  $uid            = undef,
) {

  include ::user_group::params

  $group_id   = $gid ? { undef => $uid, default => $gid }
  $group_name = $gname ? { undef => $name, default => $gname }

  # additional groups must be created before the user resource
  if $groups {
    require( Group[$groups] )
  }

  if str2bool($create_group) == true {
    group { $group_name:
            ensure => $ensure,
            gid    => $group_id,
        }
    }

  if str2bool($create_user) == true {

    $nologin_shell = $::user_group::params::nologin_shell
    $real_comment = $comment ? { undef => $name, default => $comment }
    $real_shell = $shell ? { undef => $nologin_shell, default => $shell }

    $parameters = {
      ensure         => $ensure,
      allowdupe      => $allowdupe,
      comment        => $real_comment,
      gid            => $group_name,
      groups         => $groups,
      home           => $home,
      managehome     => $managehome,
      password       => $password,
      shell          => $real_shell,
      system         => $system,
      uid            => $uid,
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

  }
}
