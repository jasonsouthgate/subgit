# subgit #

This is a Puppet module for Subgit. It installs the software through the Puppet fileserver. There is a subgit::repo definition to add required repos.

###Installing Subgit

To install the version 2.0.2 to the directory /usr/local :

    class { 'subgit': }

###Adding a repo

    subgit::repo { '/srv/repos/my_repo':
      svn_repo => 'http://my_subversion/my_project',
      svn_user => 'mylogin',
      $svn_passwd => 'passw0rd',
      svn_authors => '',
      num_authors => '10',
      registrant => '',
      registrant_email => '',
      purchase_id => '',
      registration_key => '',
      free_upgrades_until => '',
      fetch_interval_secs ='60'
    }

