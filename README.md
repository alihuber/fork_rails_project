fork_rails_project
==================

A puny script that makes a copy of an existing rails project folder and sets it
up with correct namespacing.


Description
-----------

If you are like me, you have a directory with several rails projects in it.
I also have some sort of 'standard app' in which I have already set up all the
annoying little things you have to do when starting a new project, like a basic layout.

To avoid setting things up every time I have an idea for a new app I wrote this
script. It takes 2 folder names and an arbitrary list of file- and folder names
to ignore as arguments. The command

`ruby fork_rails_project.rb old_app new_app .git`

gives you a copy (with the .git-dir omitted) of old_app, and a new app already set up
to work, meaning that all occurences of the OldApp namespace-stuff was replaced with NewApp.

This also works with engine folders, all relevant files will be automatically altered/renamed.

Requirements
-----------
Make sure you can require the activesupport gem, because the script uses the `camelize` method.

ToDo
------
* Turn into Ruby gem with binary
