autoGitPuller
=============

autoGitPuller backups Github/Bitbucket accounts automatically to your local machine/server. Its written in Ruby and has only few requirements.

Currently only supports Git backupping from Bitbucket.

Features
-------- 

* Cron friendly, setup config and just run the script
* Multitiple accounts per service
* Organizes repos to service/account/repo paths
* Uses git to only download what has changed, saving time and bandwidth

Usage
-----

1. Place autogitpuller.rb and run it.
2. Update the config file just created.
3. Make sure your ssh keys are in place and working with Git.
4. Run the application again
5. Add it to cron if you want automatic backups

License
-------

Simplified BSD License. See license.txt for the complete license.

Requirements
------------

* Ruby
* Json gem
* Git
