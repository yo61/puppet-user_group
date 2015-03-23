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

    $nologin_shell = $::user_with_group::params
    $real_comment = $comment ? { undef => $name, default => $comment }
    $real_shell = $shell ? { undef => $nologin_shell, default => $shell }

    user { $name:
      ensure         => $ensure,
      allowdupe      => $allowdupe,
      comment        => $real_comment,
      gid            => $group_name,
      groups         => $groups,
      home           => $home,
      managehome     => $managehome,
      password       => $password,
      purge_ssh_keys => $purge_ssh_keys,
      shell          => $real_shell,
      system         => $system,
      uid            => $uid,
    }

  }
}
