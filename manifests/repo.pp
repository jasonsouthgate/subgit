define subgit::repo (
  $git_repo = undef,
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
  $fetch_interval_secs ='60',
  $creates = undef )
{

  $this_git_repo = $git_repo ? {
    undef   => $name,
    default => $git_repo,
  }

  if inline_template( "<%= unless File.exists?(self.lookupvar($creates)) %>" ) {

    exec { "${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${this_git_repo}":
      require => [ Exec["/usr/bin/unzip subgit-${subgit::version}.zip"],
                   File["${subgit::install_dir}/subgit-${subgit::version}/bin/subgit"],
                   File["${subgit::install_dir}/subgit"] ],
      creates => $this_git_repo,
    }
  
    file { "${this_git_repo}/subgit/config":
      content => template("subgit/${subgit::version}/config.erb"),
      require => Exec["${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${this_git_repo}"],
    }
  
    file { "${this_git_repo}/subgit/passwd":
      content => "${svn_user} ${svn_passwd}\n",
      require => Exec["${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${this_git_repo}"],
    }
  
    file{ "${this_git_repo}/subgit/authors.txt":
      content => template("subgit/${subgit::version}/authors.txt.erb"),
      require => Exec["${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${this_git_repo}"],
    }
  
    exec { "${subgit::install_dir}/subgit/bin/subgit install ${this_git_repo}":
      require => [ File["${this_git_repo}/subgit/passwd"],
                   File["${this_git_repo}/subgit/config"],
                   File["${this_git_repo}/subgit/authors.txt"] ],
      creates => "${this_git_repo}/hooks/post-receive",
    }
  
    file { "${this_git_repo}/subgit/subgit.key":
      ensure  => 'present',
      content => template("subgit/${subgit::version}/subgit.key.erb"),
      require => Exec["${subgit::install_dir}/subgit/bin/subgit configure --svn-url ${svn_repo} ${this_git_repo}"],
      before  => Exec["${subgit::install_dir}/subgit/bin/subgit register ${this_git_repo}"],
    }
  
    exec { "${subgit::install_dir}/subgit/bin/subgit register ${this_git_repo}":
      require => Exec["${subgit::install_dir}/subgit/bin/subgit install ${this_git_repo}"],
      #creates =>
    }
  }
}
