#!/usr/bin/ruby
require "active_support/all"
require "find"
# require "pry"

# Read in two application folders.
# If not exactly 2 given, raise an error
# Does no checks for valid rails project names whatsoever
raise ArgumentError, "Wrong number of arguments (must be 2 project folders)" if ARGV.size != 2
source_project_name = ARGV[0].dup
dest_project_name = ARGV[1].dup
args = []
args << source_project_name << dest_project_name


# Cut all beginning forward slashes
args.each do |a|
  a.strip!
  if a.start_with? "/"
    a.slice!(0)
  end
end


def copy_files(dest_path)
  begin
    %x{rsync -ax --exclude .git . "#{dest_path}"}
  rescue IOError
    puts "Unable to copy files!"
  end
end


# Is folder args[0] existent/decent directory?
raise RuntimeError, "#{source_project_name} is not a valid dir!" if !File.directory?("./#{source_project_name}")

# Does the second folder already exist?
raise RuntimeError, "Destination directory already exists!" if File.directory?("./#{dest_project_name}")

# Get the base and later working direcotry for future reference
base_dir_path = Dir.pwd
dest_path = base_dir_path + "/" + dest_project_name


# Create a new source dir
begin
  %x{mkdir "#{dest_path}"}
rescue Error
  puts "Cant't create new directory!"
end

# Change to old dir, copy files to new one
Dir.chdir(base_dir_path + "/" + source_project_name)
copy_files(dest_path)

# Change to new dir
Dir.chdir(dest_path)

old_app_name = source_project_name.camelize
new_app_name = dest_project_name.camelize

# Are we inside an engine? If so, whe have to alter more files...
if File.exists?("lib/#{source_project_name}/engine.rb")
  engine_name_occurences = %x{grep -iR "#{source_project_name}" --exclude-dir=log --exclude-dir=tmp --exclude=tags .}
  engine_name_occurences = engine_name_occurences.split("\n")
  # engine_name_occurences will be something like this.
  # ./app/views/layouts/sample_engine/application.html.erb:  <%= stylesheet_link_tag    "sample_engine/application", media: "all" %>
  # ./app/views/layouts/sample_engine/application.html.erb:  <%= javascript_include_tag "sample_engine/application" %>
  # ./sample_engine.gemspec:require "sample_engine/version"
  # ./sample_engine.gemspec:  s.name        = "sample_engine"
  # ./bin/rails:ENGINE_PATH = File.expand_path('../../lib/sample_engine/engine', __FILE__)
  # ./Gemfile:# Declare your gem's dependencies in sample_engine.gemspec.
  # ./Gemfile.lock:    sample_engine (0.0.1)
  # ./Gemfile.lock:  sample_engine!
  # ./lib/sample_engine.rb:require "sample_engine/engine"
  # ./lib/tasks/sample_engine_tasks.rake:# task :sample_engine do
  # ./spec/dummy/config/application.rb:require "sample_engine"
  # ./spec/dummy/config/routes.rb:  mount SampleEngine::Engine => "/sample_engine"
  files = []
  engine_name_occurences.each do |occ|
    occ.slice!(0..1)
    file_name = occ.slice(0...occ.index(":"))
    files << file_name
  end
  files.uniq!

  begin
    files.each do |file|
      text = File.read(file)
      text = text.gsub(source_project_name, dest_project_name)
      File.open(file, "w+") { |line| line.puts text }
    end
  rescue IOError
    puts "Unable to alter new files!"
  end
  puts "Finished altering engine files without errors. Altered files:"
  files.each do |filename|
    puts filename
  end
  puts

  # we have to move some directories...
  old_file_paths = []
  Find.find(".") do |path|
    old_file_paths << path if path =~ /#{source_project_name}/
  end
  # old_file_paths will be something like this:
  #["./app/assets/images/sample_engine",
  # "./app/assets/images/sample_engine/.keep",
  # "./app/assets/javascripts/sample_engine",
  # "./app/assets/javascripts/sample_engine/application.js",
  # "./app/assets/stylesheets/sample_engine",
  # "./app/assets/stylesheets/sample_engine/application.css",
  # "./app/controllers/sample_engine",
  # "./app/controllers/sample_engine/application_controller.rb",
  # "./app/helpers/sample_engine",
  # "./app/helpers/sample_engine/application_helper.rb",
  # "./app/views/layouts/sample_engine",
  # "./app/views/layouts/sample_engine/application.html.erb",
  # "./sample_engine.gemspec",
  # "./lib/sample_engine",
  # "./lib/sample_engine/engine.rb",
  # "./lib/sample_engine/version.rb",
  # "./lib/sample_engine.rb",
  # "./lib/tasks/sample_engine_tasks.rake"]
  old_dir_names = old_file_paths.keep_if { |path| File.directory?(path) }
  dirs_to_move = Hash.new
  old_dir_names.each do |path|
    new_path = path.gsub(/#{source_project_name}/, dest_project_name)
    dirs_to_move[path] = new_path
  end
  dirs_to_move.each do |old, new|
    puts "Moving directory #{old} -> #{new}"
    `mv #{old} #{new}`
  end

  # move remaining files...
  old_file_paths = []
  Find.find(".") do |path|
    old_file_paths << path if path =~ /#{source_project_name}/
  end
  # ["./sample_engine.gemspec",
  # "./lib/sample_engine.rb",
  # "./lib/tasks/sample_engine_tasks.rake"]
  files_to_move = Hash.new
  old_file_paths.each do |path|
    new_path = path.gsub(/#{source_project_name}/, dest_project_name)
    files_to_move[path] = new_path
  end
  files_to_move.each do |old, new|
    puts "Moving file #{old} -> #{new}"
    `mv #{old} #{new}`
  end
  puts
end

# Get strings with all module name occurences of the old project name in the new project files
module_occurences = %x{grep -iR "#{old_app_name}" --exclude-dir=log --exclude-dir=tmp --exclude=tags .}
# module_occurences will be something like this. Thanks to Rails 4 namespacing,
# several configs, initializers and the router have not be altered:
# ./app/views/layouts/application.html.haml:      SampleApp
# ./config/application.rb:module SampleApp
module_occurences = module_occurences.split("\n")
files = []

module_occurences.each do |occ|
  occ.slice!(0..1)
  file_name = occ.slice(0...occ.index(":"))
  files << file_name
end

files.uniq!

begin
  files.each do |file|
    text = File.read(file)
    text = text.gsub(old_app_name, new_app_name)
    File.open(file, "w+") { |line| line.puts text }
  end
rescue IOError
  puts "Unable to alter new files!"
end

puts "Finished altering application files without errors. Altered files:"
files.each do |filename|
  puts filename
end
