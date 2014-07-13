fork_rails_project
==================

A puny litte gem that makes a copy of an existing rails project folder and sets it
up with correct namespacing.


Description
-----------

If you are like me, you have a folder with several rails projects in it.
I also have some sort of 'standard app' in which I have already set up all the
annoying little things you have to do when starting a new project, like a basic layout.

To avoid setting things up every time I have an idea for a new app I wrote this
gem. It creates a script which takes 2 folder names and an arbitrary list of
files or folder names to ignore as arguments. The command

`fork-rails-project old_app new_app .git`

gives you a copy of old_app (without the ".git" directory), and a new app already set up
to work, meaning that all occurences of the OldApp namespace are replaced with NewApp.

This also works with engine folders, all relevant files will be automatically altered/renamed.
