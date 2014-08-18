# Class: subgit
#
# This module installs and manages subgit.
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

  file { "${install_dir}":
    ensure => directory,
  }
  
  wget::fetch { "http://subgit.com/download/subgit-${version}.zip":
    destination => "${install_dir}/subgit-${version}.zip",
    require     => File[$install_dir],
  }
  
  exec { "/usr/bin/unzip subgit-${version}.zip subgit-${version}":
    cwd     => "${install_dir}",
    creates => "${install_dir}/subgit-${version}/bin/subgit",
    require => Wget::Fetch["http://subgit.com/download/subgit-${version}.zip"],
  }

  file { "${install_dir}/subgit-${version}/bin/subgit":
    ensure  => present,
    mode    => '0755',
    require => Exec["/usr/bin/unzip subgit-${version}.zip subgit-${version}"],
  }

  file { "${install_dir}/subgit":
    ensure  => link,
    target  => "${install_dir}/subgit-${version}",
    require => File[$install_dir],
  }
}
