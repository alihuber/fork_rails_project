RSpec.configure do |config|
  config.before(:all) { silence_output }

  config.color = true
  config.tty = true
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end

def silence_output
  @orig_stdout = $stdout
  $stdout = File.new("/dev/null", "w")
end

