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

def file_count_after
  Dir.chdir(TEST_DIR + "/forked_app")
  Dir["**/*"].length
end

RSpec.configure do |config|
  # uncomment next line for pry output
  config.before(:all) { silence_output }
  config.before(:each) { Dir.chdir(TEST_DIR) }

  config.after(:each)  do
    Dir.chdir(TEST_DIR)
    FileUtils.remove_dir("./forked_app") if File.directory?("./forked_app")
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
