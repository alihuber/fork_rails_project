require "active_support/all"
require "open3"
require "find"

module ForkRailsProject
  class Forker

    attr_accessor :source_project_name, :dest_project_name, :ignored_files

    def initialize(source_project_name, dest_project_name, ignored_files = [])
      @source_project_name = source_project_name
      @dest_project_name   = dest_project_name
      @ignored_files       = ignored_files
      folder_names         = [] << @source_project_name << @dest_project_name

      folder_names.each do |name|
        name.strip!
        if name.start_with?("/")
          name.slice!(0)
        end
      end

      if !File.directory?("./#{@source_project_name}")
        raise RuntimeError, "#{@source_project_name} is not a valid dir!"
      end

      if File.directory?("./#{@dest_project_name}")
        raise RuntimeError, "Destination directory already exists!"
      end
    end

    def fork!
      base_dir_path = Dir.pwd
      dest_path     = [base_dir_path, "/", @dest_project_name].join

      begin
        %x[mkdir "#{dest_path}"]
      rescue Error
        puts "Cant't create new directory!"
      end

      Dir.chdir([base_dir_path, "/", @source_project_name].join)
      copy_files(dest_path, @ignored_files)
      Dir.chdir(dest_path)

      old_app_name = @source_project_name.camelize
      new_app_name = @dest_project_name.camelize

      copy_and_rename_directories
      copy_and_rename_files
      puts

      # alter snake_cased strings
      substitute_names(@source_project_name, dest_project_name)
      puts
      # alter CamelCased strings
      substitute_names(old_app_name, new_app_name)
    end

    private

    def copy_and_rename_directories
      rename_file_objects(@source_project_name,
                          @dest_project_name) do |old_paths|
        old_paths.keep_if { |path| File.directory?(path) }
      end
    end

    def copy_and_rename_files
      # called without block: only files are copied and renamed, not directories
      rename_file_objects(@source_project_name, @dest_project_name)
    end

    def copy_files(dest_path, ignored_files)
      copy_string = "rsync -ax "
      ignored_files.each do |file_name|
        copy_string << "--exclude #{file_name} "
      end
      copy_string << ". #{dest_path}"
      begin
        puts "Copying files from #{Dir.pwd} to #{dest_path}"
        puts "Ignored files/directories: #{ignored_files.join(' ')}"
        puts "Executing #{copy_string}"
        %x[#{copy_string}]
        puts
      rescue IOError
        puts "Unable to copy files!"
      end
    end

    def rename_file_objects(old_name, new_name)
      old_file_paths = Find.find(".").flat_map do |path|
        path if path =~ /#{old_name}/
      end.compact
      old_file_paths = yield(old_file_paths) if block_given?
      files_to_move  = old_file_paths.inject({}) do |hash, path|
        new_path     = path.gsub(/#{old_name}/, new_name)
        hash[path]   = new_path
        hash
      end
      files_to_move.each do |old, new|
        puts "Renaming #{old}  ->  #{new}"
        # we don't want 'no such file' output for duplicate paths
        stdin, stdout, stderr = Open3.popen3("mv #{old} #{new}")
      end
    end

    def substitute_names(old_name, new_name)
      puts "Replacing string '#{old_name}' in application files..."
      command     = "grep -iR "\
                    "#{old_name} "\
                    "--exclude-dir=log --exclude-dir=tmp "\
                    "--exclude=tags .".squish
      occurrences = %x[#{command}]
      occurrences = occurrences.split("\n")
      files = occurrences.each.flat_map do |occ|
        occ.slice!(0..1)
        occ.slice(0...occ.index(":")) if occ.include?(":")
      end.uniq.compact

      begin
        files.each do |file|
          if File.exist?(file)
            text = File.read(file)
            text = text.gsub(old_name, new_name)
            File.open(file, "w+") { |line| line.puts text }
          end
        end
      rescue IOError
        puts "Unable to alter new files!"
      end

      puts "Finished replacing string '#{old_name}' in application files. "\
           "Altered files:"
      files.each do |filename|
        puts filename
      end
    end
  end
end
