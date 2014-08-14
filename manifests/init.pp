# Class: subgit
#
# This module installs and manages subgit, and a git mirror of a remote Subversion repo.
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class subgit (
  $version = '2.0.2',
  $install_dir = '/usr/local' )
{

  file { $install_dir:
    ensure => directory,
  }

  file { "${install_dir}/subgit-${version}":
    ensure  => directory,
    source  => "puppet:///modules/subgit/${version}",
    mode    => '0644',
    recurse => true,
    ignore  => '.svn',
    require => File[$install_dir],
  }

  file { "${install_dir}/subgit-${version}/bin/subgit":
    ensure  => present,
    source  => "puppet:///modules/subgit/${version}/bin/subgit",
    mode    => '0755',
    require => File[$install_dir],
  }

  file { "${install_dir}/subgit":
    ensure  => link,
    target  => "${install_dir}/subgit-${version}",
    require => File[$install_dir],
  }
}
