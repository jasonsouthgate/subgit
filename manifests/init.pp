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
  $registrant,
  $registrant_email,
  $purchase_id,
  $registration_key,
  $num_of_committers = '10',
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

  #TODO: this user data needs moving out into heira
  file { "${git_repo}/subgit/passwd":
    content => "jsouthga Salamander_44\n",
    before  => Exec["${install_dir}/subgit/bin/subgit install ${git_repo}"],
    require => Exec["${install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}"],
  }

  exec { "${install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}":
    require => [ File["${install_dir}/subgit-${version}"],
                 File["${install_dir}/subgit-${version}/bin/subgit"],
                 File["${install_dir}/subgit"] ],
    creates => $git_repo,
  }

  exec { "${install_dir}/subgit/bin/subgit install ${git_repo}":
    #TODO: this needs stopping for idempotency
    require => File["${git_repo}/subgit/passwd"],
  }

  file { "${git_repo}/subgit/subgit.key":
    ensure  => 'present',
    source  => "puppet:///modules/subgit/${version}/subgit.key",
    require => Exec["${install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}"],
    #before  => Exec["${install_dir}/subgit/bin/subgit register ${git_repo}"],
  }

#  exec { "${install_dir}/subgit/bin/subgit register ${git_repo}":
#    #TODO: this needs stopping for idempotency
#    require => Exec["${install_dir}/subgit/bin/subgit install ${git_repo}"],
#  }

}
