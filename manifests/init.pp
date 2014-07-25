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
  $install_dir = '/usr/local',
  $svn_repo,
  $git_repo,
  $working_tree,
  $fetch_interval ='60' ){

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

  file {"${git_repo}/subgit/config":
    source => template("subgit/${version}/config.erb"),
  }

  exec {'subgit configure':
    command => "${install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}",
    require => [ File["${install_dir}/subgit-${version}"], File["${install_dir}/subgit"] ],
  } ->

  exec {'subgit install':
    command => "${install_dir}/subgit/bin/subgit install ${git_repo}",
  } ->

  exec {'git clone':
    path    => ['/usr/bin', '/bin'],
    command => "git clone ${git_repo} ${working_tree}",
    require => Package['git'],
  }

}
