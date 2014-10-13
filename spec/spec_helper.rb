RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.before(:all) { silence_output }
end

def silence_output
  @orig_stdout = $stdout
  $stdout = File.new("/dev/null", "w")
end

