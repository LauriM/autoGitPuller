autoGitPuller
=============

autoGitPuller backups Github/Bitbucket accounts automatically to your local machine/server. Its written in Ruby and has few requirements to work.

Currently only supports Git backupping from Bitbucket.

Features
-------- 

* Cron friendly, setup config and just run the script
* Multitiple accounts per service
* Organizes repos to service/account/repo paths
* Uses git to only download what has changed, saving time and bandwidth

Usage
-----

1) Place autogitpuller.rb anywhere you want.
2) Create ~/.autogitpuller.rb using config_template.yaml as example.
3) Make sure you have ssh keys in place for all services you want to use.
4) Run autogitpuller.rb
5) Add it to cron for automatic backupping

License
-------

Simplified BSD License. See license.txt for the complete license.

Requirements
------------

* Ruby
* Json gem
* Git
