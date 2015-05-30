require "spec_helper"
require "fileutils"
require "forker"
require "pry"
require "forker_examples"

describe ForkRailsProject::Forker do

  let(:forker) { described_class.new("orig_app", "forked_app") }

  it "does create a new directory with the given name" do
    forker.fork!

    expect(File.directory?("../forked_app")).to be_truthy
    expect(Dir.pwd).to eq TEST_DIR + "/forked_app"
  end


  describe "normal project fork with no ignored files" do
    let(:forker) { described_class.new("orig_app", "forked_app") }

    it_behaves_like :basic_file_movement
    it_behaves_like :moving_files_in_normal_app
    it_behaves_like :renaming_file_objects_in_normal_app

    it "does copy all files" do
      forker.fork!

      expect(app_file_count_before).to eql file_count_after
    end
  end


  describe "normal project fork with ignored files" do
    let(:forker) do
      described_class.new("orig_app", "forked_app", ["ignore.me"])
    end

    it_behaves_like :basic_file_movement
    it_behaves_like :moving_files_in_normal_app
    it_behaves_like :renaming_file_objects_in_normal_app

    it "does not copy ignored files" do
      forker.fork!

      expect(file_count_after).to eql app_file_count_before - 1
    end
  end


  describe "normal project fork with ignored files and folders" do
    let(:forker) do
      described_class.new("orig_app", "forked_app", ["ignore.me", "tmp"])
    end

    it_behaves_like :basic_file_movement
    it_behaves_like :moving_files_in_normal_app
    it_behaves_like :renaming_file_objects_in_normal_app

    it "does not copy ignored files and folders" do
      forker.fork!

      expect(file_count_after).to eql app_file_count_before - 3
    end
  end


  describe "engine fork with no ignored files" do
    let(:forker) { described_class.new("orig_engine", "forked_app") }

    it_behaves_like :basic_file_movement
    it_behaves_like :moving_files_in_engine
    it_behaves_like :renaming_file_objects_in_engine
  end


  describe "engine fork with ignored files" do
    let(:forker) do
      described_class.new("orig_engine", "forked_app", ["ignore.me"])
    end

    it_behaves_like :basic_file_movement
    it_behaves_like :moving_files_in_engine
    it_behaves_like :renaming_file_objects_in_engine

    it "does not copy ignored files" do
      forker.fork!

      expect(file_count_after).to eql engine_file_count_before - 1
    end
  end


  describe "engine fork with ignored files and folders" do
    let(:forker) do
      described_class.new("orig_engine", "forked_app", ["ignore.me", "tmp"])
    end

    it_behaves_like :basic_file_movement
    it_behaves_like :moving_files_in_engine
    it_behaves_like :renaming_file_objects_in_engine

    it "does not copy ignored files and folders" do
      forker.fork!

      expect(file_count_after).to eql engine_file_count_before - 3
    end
  end


  describe "forking of fancy namespaced component based applications" do
    let(:forker) { described_class.new("fancy_app", "forked_app") }
    let(:namespaced_engine_path_1) {
        "engines/forked_app_core/app/controllers/forked_app_core/"\
        "namespace/namespaced_controller.rb" }
    let(:namespaced_engine_path_2) {
        "engines/forked_app_mailer/app/mailers/forked_app_mailer/"\
        "namespace/welcome_mailer.rb" }
    let(:changed_file_contents_1) {
      File.open(namespaced_engine_path_1, "rb").read
    }
    let(:changed_file_contents_2) {
      File.open(namespaced_engine_path_2, "rb").read
    }

    it "does copy all files" do
      forker.fork!

      expect(fancy_app_file_count_before).to eql file_count_after
    end

    it "works with file path substrings" do
      forker.fork!

      path_names = read_file_paths
      expect(path_names).to include namespaced_engine_path_1
      expect(path_names).to include namespaced_engine_path_2
    end

    it "does remove all snake_cased and CamelCased occurrences"\
       " of original app name in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.include?("fancy_app")).to be_falsey
      expect(file_contents.include?("FancyApp")).to be_falsey
    end

    it "does alter file contents correctly in namespaced files" do
      forker.fork!

      expect(changed_file_contents_1).not_to include "FancyAppCore"
      expect(changed_file_contents_1).to     include "ForkedAppCore"
      expect(changed_file_contents_2).not_to include "FancyAppMailer"
      expect(changed_file_contents_2).to     include "ForkedAppMailer"
    end
  end


  # test only applicable if grep output does not match './file_path: occurrence'
  # describe "flawed grep output" do
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
