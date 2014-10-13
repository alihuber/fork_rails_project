require "spec_helper"
require "fileutils"
require "active_support/all"
require "find"
require "forker"
require "pry"
require "forker_examples"

describe ForkRailsProject::Forker do

  after(:each) do
    Dir.chdir("../")
    FileUtils.remove_dir("./forked_app") if File.directory?("./forked_app")
  end

  let(:forker) { described_class.new("orig_app", "forked_app") }

  it "does create a new directory with the given name" do
    Dir.chdir("./spec/test/")
    forker.fork!
    # forker switches to folder to fork
    expect(File.directory?("../forked_app")).to be_truthy
  end


  describe "normal project fork with no ignored files" do
    let(:forker) { described_class.new("orig_app", "forked_app") }

    it_behaves_like :copying_files_and_altering_strings

    it "does copy all files" do
      Dir.chdir("./orig_app")
      count_before = Dir["**/*"].length
      Dir.chdir("../")
      forker.fork!

      Dir.chdir("../forked_app")
      count_after = Dir["**/*"].length
      expect(count_before).to eql count_after
    end
  end


  describe "normal project fork with ignored files" do
    let(:forker) { described_class.new("orig_app", "forked_app", ["ignore.me"]) }

    it_behaves_like :copying_files_and_altering_strings

    it "does not copy ignored files" do
      Dir.chdir("./orig_app")
      count_before = Dir["**/*"].length
      Dir.chdir("../")
      forker.fork!

      Dir.chdir("../forked_app")
      count_after = Dir["**/*"].length
      expect(count_after).to eql count_before - 1
    end
  end


  describe "normal project fork with ignored files and folders" do
    let(:forker) { described_class.new("orig_app", "forked_app", ["ignore.me", "tmp"]) }

    it_behaves_like :copying_files_and_altering_strings

    it "does not copy ignored files and folders" do
      Dir.chdir("./orig_app")
      count_before = Dir["**/*"].length
      Dir.chdir("../")
      forker.fork!

      Dir.chdir("../forked_app")
      count_after = Dir["**/*"].length
      expect(count_after).to eql count_before - 3
    end
  end
end

