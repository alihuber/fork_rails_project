require "spec_helper"
require "fileutils"
require "active_support/all"
require "find"
require "forker"
require "pry"

describe ForkRailsProject::Forker do

  after(:all) do
    Dir.chdir("../")
    FileUtils.remove_dir("./forked_app") if File.directory?("./forked_app")
  end

  let(:forker) { described_class.new("orig_app", "forked_app")}

  it "does create a new directory with the given name" do
    Dir.chdir("./spec/test/")
    forker.fork!
    # forker switches to folder to fork
    expect(File.directory?("../forked_app")).to be_truthy
  end
end

