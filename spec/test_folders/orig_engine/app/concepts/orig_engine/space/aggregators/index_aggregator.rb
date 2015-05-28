module OrigEngine
  class Space < ActiveRecord::Base
    class IndexAggregator
      load_data :records do
        self.records = OrigEngine::Space.new
      end
    end
  end
end
