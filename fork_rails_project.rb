#!/usr/bin/ruby
require "active_support/all"
require "find"
# require "pry"


def copy_files(dest_path)
  begin
    %x{rsync -ax --exclude .git . "#{dest_path}"}
  rescue IOError
    puts "Unable to copy files!"
  end
end

def rename_file_objects(old_name, new_name)
  old_file_paths = []
  Find.find(".") do |path|
    old_file_paths << path if path =~ /#{old_name}/
  end
  old_file_paths = yield(old_file_paths) if block_given?
  files_to_move = Hash.new
  old_file_paths.each do |path|
    new_path = path.gsub(/#{old_name}/, new_name)
    files_to_move[path] = new_path
  end
  files_to_move.each do |old, new|
    puts "Renaming #{old}  ->  #{new}"
    `mv #{old} #{new}`
  end
end

def substitute_names(old_name, new_name)
  occurrence = %x{grep -iR "#{old_name}" --exclude-dir=log --exclude-dir=tmp --exclude=tags .}
  occurrence = occurrence.split("\n")
  files = []
  occurrence.each do |occ|
    occ.slice!(0..1)
    file_name = occ.slice(0...occ.index(":"))
    files << file_name
  end
  files.uniq!

  begin
    files.each do |file|
      text = File.read(file)
      text = text.gsub(old_name, new_name)
      File.open(file, "w+") { |line| line.puts text }
    end
  rescue IOError
    puts "Unable to alter new files!"
  end

  puts "Finished replacing string '#{old_name}' in application files. Altered files:"
  files.each do |filename|
    puts filename
  end
end


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
  substitute_names(source_project_name, dest_project_name)
  puts

  rename_file_objects(source_project_name, dest_project_name) do |old_paths|
    old_paths.keep_if { |path| File.directory?(path) }
  end

  rename_file_objects(source_project_name, dest_project_name)
  puts
end

substitute_names(old_app_name, new_app_name)
