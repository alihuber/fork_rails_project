fork_rails_project
==================

A puny litte gem that makes a copy of an existing rails project folder and sets it
up with correct namespacing.


Description
-----------

If you are like me, you have a folder with several rails projects in it.
I also have some sort of 'standard app' in which I have already set up all the boilerplate for a new rails app e.g. gems I use every time and basic Bootstrap layout etc.

To avoid copying the folder by hand and setting things up every time I have an idea for a new app I wrote this
gem. It provides a command that takes 2 folder names and an arbitrary list of files or folder names to ignore as arguments. The command

`fork-rails-project old_app new_app .git tmp`

gives you a copy of `old_app` (with the ".git" and "tmp" files/folders omitted), and a `new app` folder already set up to work, meaning that in all files all occurences of the `OldApp` namespace are replaced with `NewApp`, all occurences of the `old_app` project name are replaced with `new_app` and all folders/file paths are moved and renamed accordingly.

This is particularly useful to quickly rename Rails engines that live in their own namespace.

If you are using some sort of component based Rails application approach in which several sub-engines are located somewhere inside the main application you are in luck! For example, if you have an application set up like this:
```
fancy_app
├── app
├── controllers
└── engines
    └── fancy_app_api
        └── app
            └── controllers
                └── fancy_app_api
                    └── register
                        └── register_controller.rb
```
the command `fork-rails-project fancy_app forked_app` issued on the main folder will produce this:
```
forked_app
├── app
├── controllers
└── engines
    └── forked_app_api
        └── app
            └── controllers
                └── forked_app_api
                    └── register
                        └── register_controller.rb
```
again with all file paths and all strings in all files changed accordingly.

Since I can't possibly test all whacky corner cases and weird project layouts out there, this script should work for simple renamings and setups such as above. Use it with caution and on one subfolder after another when in doubt.
