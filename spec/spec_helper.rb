TEST_DIR = Dir.pwd + "/spec/test_folders"

def app_file_count_before
  Dir.chdir(TEST_DIR + "/orig_app")
  count_before = Dir["**/*"].length
  Dir.chdir("../")
  count_before
end

def engine_file_count_before
  Dir.chdir(TEST_DIR + "/orig_engine")
  count_before = Dir["**/*"].length
  Dir.chdir("../")
  count_before
end

def fancy_app_file_count_before
  Dir.chdir(TEST_DIR + "/fancy_app")
  count_before = Dir["**/*"].length
  Dir.chdir("../")
  count_before
end

def file_count_after
  Dir.chdir(TEST_DIR + "/forked_app")
  Dir["**/*"].length
end

def read_file_contents
  Dir.chdir(TEST_DIR + "/forked_app")
  files = Dir.glob("**/*")
  file_contents = ""
  files.each do |file|
    File.open(file) { |f| file_contents << f.read unless File.directory?(f) }
  end
  file_contents
end

def read_file_paths
  Dir.chdir(TEST_DIR + "/forked_app")
  Dir.glob("**/*").join(" ")
end


RSpec.configure do |config|
  # comment next line for pry
  config.before(:all) { silence_output }
  config.before(:each) do
    Dir.chdir(TEST_DIR)
    FileUtils.rm_rf("./forked_app") if File.directory?("./forked_app")
  end

  config.after(:each)  do
    Dir.chdir(TEST_DIR)
    FileUtils.rm_rf("./forked_app") if File.directory?("./forked_app")
  end

  config.run_all_when_everything_filtered = true
  config.color                            = true
  config.tty                              = true
  config.filter_run                       :focus
end

def silence_output
  @orig_stdout = $stdout
  $stdout      = File.new("/dev/null", "w")
end
