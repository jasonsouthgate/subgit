define repo (
  $git_repo,
  $svn_repo,
  $svn_user,
  $svn_passwd,
  $svn_authors,
  $num_authors = '10',
  $registrant,
  $registrant_email,
  $purchase_id,
  $registration_key,
  $free_upgrades_until,
  $fetch_interval_secs ='60' )
{

  exec { "${install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}":
    require => [ File["${subgit::install_dir}/subgit-${subgit::version}"],
                 File["${subgit::install_dir}/subgit-${subgit::version}/bin/subgit"],
                 File["${subgit::install_dir}/subgit"] ],
    creates => $git_repo,
  }

  file { "${git_repo}/subgit/config":
    content => template("subgit/${subgit::version}/config.erb"),
    require => Exec["${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}"],
  }

  file { "${git_repo}/subgit/passwd":
    content => "${svn_user} ${svn_passwd}\n",
    require => Exec["${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}"],
  }

  file{ "${git_repo}/subgit/authors.txt":
    content => template("subgit/${subgit::version}/authors.txt.erb"),
  }

  exec { "${subgit::install_dir}/subgit/bin/subgit install ${git_repo}":
    require => [ File["${git_repo}/subgit/passwd"],
                 File["${git_repo}/subgit/config"],
                 File["${git_repo}/subgit/authors.txt"] ],
    creates => "${git_repo}/hooks/post-receive",
  }

  file { "${git_repo}/subgit/subgit.key":
    ensure  => 'present',
    content => template("subgit/${subgit_version}/subgit.key"),
    require => Exec["${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${git_repo}"],
    before  => Exec["${subgit::install_dir}/subgit/bin/subgit register ${git_repo}"],
  }

  exec { "${subgit::install_dir}/subgit/bin/subgit register ${git_repo}":
    require => Exec["${subgit::install_dir}/subgit/bin/subgit install ${git_repo}"],
    #creates =>
  }
}
