shared_examples_for :copying_files_and_altering_strings do

  context "basic file operations" do
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

