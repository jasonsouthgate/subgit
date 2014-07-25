This is a README file for SubGit version 2.0.2 ('Patrick') build #2731.

* What is SubGit?

SubGit is a server side solution for smooth migration from Subversion to Git and back.

* How to use SubGit to build a writable Git mirror of a local Subversion repository?

Do the following:

> svnadmin create svn_repos
> subgit configure svn_repos
> subgit install svn_repos
> git clone repos repos-git

Now work with Subversion 'repos' and Git 'gt' repositories as usually.

* How to use SubGit to build a writable Git mirror of a remote Subversion repository?

Do the following:

> subgit configure --svn-url SVN_URL git_repos
> subgit install git_repos

Now you may clone git_repos and use clone as usually.

* How to upgrade from the previous version:

Run:

>  subgit install svn_repos

or:

>  subgit install --rebuild svn_repos

to retranslate Subversion revisions to Git commits.

* Where to look for help and additional information?

SubGit web site       : http://subgit.com/
SubGit issues tracker : http://issues.tmatesoft.com/issues/SGT
SubGit mailing list   : send email to subgit-user-subscribe@subgit.com

* Third-party components

SubGit includes and uses number of third-party libraries. 
Licenses for these libraries may be found in the 'lib/licenses' folder of the distribution archive.  

* Distribution policy.

You may use and redistribute this version of the application for free.

SubGit is proprietary software and all rights to it belongs to TMate Software s.r.o.

This software is distributed as is without warranty of any kind, either expressed or implied, including 
but not limited to the implied warranties of merchantability and fitness for a particular purpose. 
TMate Software does not assume any liability for any alleged or actual damages arising from the use of any of these products.
