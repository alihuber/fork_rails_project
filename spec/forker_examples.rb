shared_examples_for :basic_file_movement do
  context "basic file operations" do
    it "does remove all snake_cased and CamelCased occurrences"\
       " of original app name in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.include?("orig_app")).to be_falsey
      expect(file_contents.include?("OrigApp")).to be_falsey
    end
  end
end


shared_examples_for :moving_files_in_normal_app do
  context "altering app name strings" do
    it "does replace all snake_cased and CamelCased occurrences"\
       " of original app name in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.scan(/forked_app/).length).to eq 11
      expect(file_contents).to include "forked_app_namespaced_api"
      expect(file_contents.scan(/ForkedApp/).length).to eq 3
    end
  end
end


shared_examples_for :renaming_file_objects_in_normal_app do
  context "altering file paths" do
    it "does remove all file objects containing original app name" do
      forker.fork!

      path_names = read_file_paths
      expect(path_names.include?("orig_app")).to be_falsey
      expect(path_names.scan(/forked_app/).length).to eq 2
    end
  end
end


shared_examples_for :moving_files_in_engine do
  context "altering app name strings" do
    it "does replace all snake_cased and CamelCased occurrences"\
       " of original app name in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.scan(/forked_app/).length).to eq 13
      expect(file_contents.scan(/ForkedApp/).length).to eq 32
      expect(file_contents).to include "ForkedAppMailer"
    end
  end
end


shared_examples_for :renaming_file_objects_in_engine do
  context "altering file paths" do
    it "does remove all file objects containing original app name" do
      forker.fork!

      path_names = read_file_paths
      expect(path_names.include?("orig_app")).to be_falsey
      expect(path_names.scan(/forked_app/).length).to eq 26
    end
  end
end
