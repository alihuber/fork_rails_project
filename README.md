fork_rails_project
==================

A puny script that makes a copy of an existing rails project folder and sets it up.


Description
-----------

If you are like me, you have a folder on your computer with several rails projects in it.
I also have some sort of 'standard app', in which I have already set up all the annoying little
things I always forget when starting a new app, like bootstrap set up and CoffeeScript deactivated.

To avoid setting things up every time I have an idea for a new app, I wrote this script.
It lets one do this:
Suggest you are in the directory with your rails apps:

ruby fork_rails_project.rb old_app new_app

Now you get a copy (with the .git-dir omitted) of old_app, and a new app already set up
to work, meaning that all occurences of the OldApp namespace-stuff was replaced with NewApp.
