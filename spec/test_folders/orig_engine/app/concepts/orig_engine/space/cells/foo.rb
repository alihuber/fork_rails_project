load "#{OrigEngine::Engine.root.to_s}/app/concepts/orig_engine/"\
  "space/cells/main_cell.rb"

module OrigEngine
  class Space::Cells::Foo
    def show
      render(view: :foo,
             base: ["#{OrigEngine::Engine.root.to_s}/app/concepts"])
    end
  end
end
