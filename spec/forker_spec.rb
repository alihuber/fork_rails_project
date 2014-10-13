require "spec_helper"
require "fileutils"
require "active_support/all"
require "find"
require "forker"
require "pry"

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

  describe "normal projekt fork with no ignored files" do
    it "does copy all files" do
      Dir.chdir("./orig_app")
      count_before = Dir["**/*"].length
      Dir.chdir("../")
      forker.fork!

      Dir.chdir("../forked_app")
      count_after = Dir["**/*"].length
      expect(count_before).to eql count_after
    end

    it "does remove all snake_cased occurrences of original app name in forked app" do
      forker.fork!
      Dir.chdir("../forked_app")
      files = Dir.glob("**/*")
      file_contents = ""
      files.each do |file|
        File.open(file) { |f| file_contents << f.read unless File.directory?(f) }
      end

      expect(file_contents.include?("orig_app")).to be_falsey
    end

    it "does remove all CamelCased occurrences of original app name in forked app" do
      forker.fork!
      Dir.chdir("../forked_app")
      files = Dir.glob("**/*")
      file_contents = ""
      files.each do |file|
        File.open(file) { |f| file_contents << f.read unless File.directory?(f) }
      end

      expect(file_contents.include?("OrigApp")).to be_falsey
    end

    it "does rename all snake_cased occurrences of original app name in forked app" do
      forker.fork!
      Dir.chdir("../forked_app")
      files = Dir.glob("**/*")
      file_contents = ""
      files.each do |file|
        File.open(file) { |f| file_contents << f.read unless File.directory?(f) }
      end

      expect(file_contents.scan(/forked_app/).length).to eq 1
    end

    it "does rename all CamelCased occurrences of original app name in forked app" do
      forker.fork!
      Dir.chdir("../forked_app")
      files = Dir.glob("**/*")
      file_contents = ""
      files.each do |file|
        File.open(file) { |f| file_contents << f.read unless File.directory?(f) }
      end

      expect(file_contents.scan(/ForkedApp/).length).to eq 2
    end
  end
end

