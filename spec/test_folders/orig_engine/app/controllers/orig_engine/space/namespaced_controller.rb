module OrigEngine
  module Space
    class NamespacedController < OrigEngine::ApplicationController

      def update
        ::OrigEngine::Service.call
        redirect_to orig_engine.space_index_path
      end

    end
  end
end
