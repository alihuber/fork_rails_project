shared_examples_for :basic_file_movement do
  context "basic file operations" do
    it "does remove all snake_cased occurrences of original app name "\
       "in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.include?("orig_app")).to be_falsey
    end

    it "does remove all CamelCased occurrences of original app name "\
       "in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.include?("OrigApp")).to be_falsey
    end
  end
end


shared_examples_for :moving_files_in_normal_app do
  context "altering app name strings" do
    it "does rename all snake_cased occurrences of original app name "\
       "in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.scan(/forked_app/).length).to eq 2
    end

    it "does rename all CamelCased occurrences of original app name "\
       "in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.scan(/ForkedApp/).length).to eq 2
    end
  end
end


shared_examples_for :renaming_file_objects_in_normal_app do
  context "altering file paths" do
    it "does remove all file objects containing original app name" do
      forker.fork!

      path_names = read_file_paths
      expect(path_names.include?("orig_app")).to be_falsey
    end

    it "does rename all file objects containing original app name" do
      forker.fork!

      path_names = read_file_paths
      expect(path_names.scan(/forked_app/).length).to eq 1
    end
  end
end


shared_examples_for :moving_files_in_engine do
  context "altering app name strings" do
    it "does rename all snake_cased occurrences of original app name "\
       "in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.scan(/forked_app/).length).to eq 6
    end

    it "does rename all CamelCased occurrences of original app name "\
       "in forked app" do
      forker.fork!

      file_contents = read_file_contents
      expect(file_contents.scan(/ForkedApp/).length).to eq 14
    end
  end
end


shared_examples_for :renaming_file_objects_in_engine do
  context "altering file paths" do
    it "does remove all file objects containing original app name" do
      forker.fork!

      path_names = read_file_paths
      expect(path_names.include?("orig_app")).to be_falsey
    end

    it "does rename all file objects containing original app name" do
      forker.fork!

      path_names = read_file_paths
      expect(path_names.scan(/forked_app/).length).to eq 10
    end
  end
end
