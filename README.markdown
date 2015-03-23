####Table of Contents

1. [Overview - What is the user_group module?](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with user_group](#setup)
    * [What user_group affects](#what-user_group-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with user_group](#beginning-with-user_group)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

A simple wrapper to aid the creation of users/groups.

##Module Description

This module is a convenience wrapper around the native puppet user and group resource types to make it easy to create a user with a group having the same name and id.

##Setup

###What user_group affects

The user_group define creates users/groups.

###Beginning with user_group

To create a new user and a group with the same name:

```puppet
  user_group{'my_user':}
```

##Usage

###Classes and Defined Types

####Defined Type: `user_group`

Creates a user and (by default) a group with the same name.

```puppet
  user_group{'my_user':}
```

**Parameters within `user_group`:**
#####`ensure`
#####`create_group`
#####`create_user`
#####`gname`
#####`allowdupe`
#####`comment`
#####`gid`
#####`groups`
#####`home`
#####`managehome`
#####`password`
#####`purge_ssh_keys`
#####`shell`
#####`system`
#####`uid`

##Reference

###Classes

####Public Classes

There are no public classes in this module.

####Private Classes

* `user_group::params`: defines OS-specific defaults

###Defined Types

####Public Defined Types

* `user_group`: Creates a user and a group with the same name

##Limitations

This module should work on all platforms supported by puppet but has not been tested on anything other than CentOS 7.

##Development

Feel free to improve anything.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

