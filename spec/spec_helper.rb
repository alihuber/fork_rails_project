TEST_DIR = Dir.pwd + "/spec/test_folders"

RSpec.configure do |config|
  # uncomment next line for pry output
  config.before(:all) { silence_output }

  config.run_all_when_everything_filtered = true
  config.color                            = true
  config.tty                              = true
  config.filter_run                       :focus
end

def silence_output
  @orig_stdout = $stdout
  $stdout      = File.new("/dev/null", "w")
end
