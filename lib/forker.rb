require "active_support/all"
require "find"

module ForkRailsProject
  class Forker

    attr_accessor :source_project_name, :dest_project_name, :ignored_files

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
      puts "Replacing string '#{old_name}' in application files..."
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

      puts "Finished replacing string '#{old_name}' in application files."\
        " Altered files:"
      files.each do |filename|
        puts filename
      end
    end


    def initialize(source_project_name, dest_project_name, ignored_files = [])
      @source_project_name = source_project_name
      @dest_project_name   = dest_project_name
      @ignored_files       = ignored_files
      folder_names = []
      folder_names << @source_project_name << @dest_project_name

      folder_names.each do |a|
        a.strip!
        if a.start_with? "/"
          a.slice!(0)
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
      base_dir_path   = Dir.pwd
      dest_path       = base_dir_path + "/" + @dest_project_name

      begin
        %x{mkdir "#{dest_path}"}
      rescue Error
        puts "Cant't create new directory!"
      end

      Dir.chdir(base_dir_path + "/" + @source_project_name)
      copy_files(dest_path, @ignored_files)
      Dir.chdir(dest_path)

      old_app_name = @source_project_name.camelize
      new_app_name = @dest_project_name.camelize

      # Are we inside an engine? If so, we have to rename some files and folders
      if File.exists?("lib/#{@source_project_name}/engine.rb")
        rename_file_objects(@source_project_name, @dest_project_name) do |old_paths|
          old_paths.keep_if { |path| File.directory?(path) }
        end

        rename_file_objects(@source_project_name, @dest_project_name)
        puts
      end

      substitute_names(@source_project_name, dest_project_name)
      puts
      substitute_names(old_app_name, new_app_name)
    end
  end
end
