#!/usr/bin/ruby
require 'active_support/all'

# Read in two application folders.
# If not exactly 2 given, raise an error
# Does no checks for valid rails project names whatsoever
raise ArgumentError, 'Wrong number of arguments (must be 2 project folders)' if ARGV.size != 2
source_proj = ARGV[0].dup
dest_proj = ARGV[1].dup
args = []
args << source_proj << dest_proj


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
    puts "Not able to copy files!"
    System.exit(1)
  end
end


# Is folder args[0] existent/decent directory?
raise RuntimeError, "#{source_proj} is not a valid dir!" if !File.directory?("./#{source_proj}")

# Does the second folder already exist?
raise RuntimeError, "Destination directory does already exist!" if File.directory?("./#{dest_proj}")

# Get the base and later wd for future reference
base_dir_path = Dir.pwd
dest_path = base_dir_path + "/" + dest_proj


# Create a new source dir
begin
  %x{mkdir "#{dest_path}"}
rescue Error
  puts "Cant't create new directory!"
  System.exit(1)
end

# Change to old dir, copy files to new one
Dir.chdir(base_dir_path + "/" + source_proj)
copy_files(dest_path)

# Change to new dir
Dir.chdir(dest_path)

old_app_name = source_proj.camelize
new_app_name = dest_proj.camelize

# Get string with all occurences of the old project name in the new project files
occurences = %x{grep -iR "#{old_app_name}" ./}

# Gives us something like this:
# "./config/application.rb:module SampleApp\n
# ./config/environment.rb:SampleApp::Application.initialize!\n
# ./config/environments/development.rb:SampleApp::Application.configure do\n
# ./config/environments/production.rb:SampleApp::Application.configure do\n
# ./config/environments/test.rb:SampleApp::Application.configure do\n
# ./config/initializers/secret_token.rb:SampleApp::Application.config.secret_token = '7f7309bf1d1684eb605522ff541ce6e85934303ca23d1224c8cf2a5d15b6cc33bdb85ffc0a1dacf473e220a58fbc3da1133ea66069aceccf19d8877f76fad656'\n
# ./config/initializers/session_store.rb:SampleApp::Application.config.session_store :cookie_store, key: '_sample_app_session'\n
# ./config/initializers/session_store.rb:# SampleApp::Application.config.session_store :active_record_store\n
# ./config/routes.rb:SampleApp::Application.routes.draw do\n
# ./config.ru:run SampleApp::Application\n
# ./Rakefile:SampleApp::Application.load_tasks\n"

occurences = occurences.split("\n")

files = []

occurences.each do |occ|
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
