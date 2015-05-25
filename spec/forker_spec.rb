require "spec_helper"
require "fileutils"
require "forker"
require "pry"
require "forker_examples"

describe ForkRailsProject::Forker do

  after(:each) do
    Dir.chdir(TEST_DIR)
    FileUtils.remove_dir("./forked_app") if File.directory?("./forked_app")
  end

  let(:forker) { described_class.new("orig_app", "forked_app") }

  it "does create a new directory with the given name" do
    Dir.chdir(TEST_DIR)
    forker.fork!
    # forker switches to folder to fork
    expect(File.directory?("../forked_app")).to be_truthy
  end


  describe "normal project fork with no ignored files" do
    let(:forker) { described_class.new("orig_app", "forked_app") }

    it_behaves_like :moving_basic_files
    it_behaves_like :moving_files_in_normal_app

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
    let(:forker) do
      described_class.new("orig_app", "forked_app", ["ignore.me"])
    end

    it_behaves_like :moving_basic_files
    it_behaves_like :moving_files_in_normal_app

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
    let(:forker) do
      described_class.new("orig_app", "forked_app", ["ignore.me", "tmp"])
    end

    it_behaves_like :moving_basic_files
    it_behaves_like :moving_files_in_normal_app

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

  describe "engine fork with no ignored files" do
    let(:forker) { described_class.new("orig_engine", "forked_app") }

    it_behaves_like :moving_basic_files
    it_behaves_like :moving_files_in_engine
    it_behaves_like :renaming_file_objects_in_engine
  end

  describe "engine fork with ignored files" do
    let(:forker) do
      described_class.new("orig_engine", "forked_app", ["ignore.me"])
    end

    it_behaves_like :moving_basic_files
    it_behaves_like :moving_files_in_engine
    it_behaves_like :renaming_file_objects_in_engine

    it "does not copy ignored files" do
      Dir.chdir("./orig_engine")
      count_before = Dir["**/*"].length
      Dir.chdir("../")
      forker.fork!

      Dir.chdir("../forked_app")
      count_after = Dir["**/*"].length
      expect(count_after).to eql count_before - 1
    end
  end

  describe "engine fork with ignored files and folders" do
    let(:forker) do
      described_class.new("orig_engine", "forked_app", ["ignore.me", "tmp"])
    end

    # if focus
    # Dir.chdir(TEST_DIR)
    it_behaves_like :moving_basic_files
    it_behaves_like :moving_files_in_engine
    it_behaves_like :renaming_file_objects_in_engine

    it "does not copy ignored files and folders" do
      Dir.chdir("./orig_engine")
      count_before = Dir["**/*"].length
      Dir.chdir("../")
      forker.fork!

      Dir.chdir("../forked_app")
      count_after = Dir["**/*"].length
      expect(count_after).to eql count_before - 3
    end
  end

  # test only applicable if grep output does not match './file_path: occurrence'
  # describe "flawed grep output" do
  #   Dir.chdir(TEST_DIR)
  #   let(:forker) { described_class.new("orig_app", "forked_app") }
  #   subject { forker.fork! }

  #   # tested with e.g. 'grep -rli'
  #   fit "does not raise an error" do
  #     expect {
  #       subject
  #     }.not_to raise_error
  #   end
  # end
end
