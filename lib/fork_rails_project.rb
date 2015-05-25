#!/usr/bin/ruby
require "forker"


source_project_name = ARGV[0].dup
dest_project_name   = ARGV[1].dup
ignored_files       = ARGV[2..-1]

forker = ForkRailsProject::Forker.new(source_project_name,
                                      dest_project_name,
                                      ignored_files)
forker.fork!
