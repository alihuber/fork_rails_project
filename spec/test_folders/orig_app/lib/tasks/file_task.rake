namespace :orig_app do
  FILES = {
    api: "orig_app_api.js"
  }


  FILES.each do |name, file|
    desc "Copy orig_app_#{name}.js"
    task "copy_#{name}_js" do
      source_file_name =
        Rake::FileList.new("public/assets/orig_app_#{name}-*.js")
      target_file_name =
        Rails.root.join("engines", "orig_engine", "spec", "dummy", "public",
                        "assets", "orig_app_#{name}.js")
      cp source_file_name, target_file_name
    end
  end
end
