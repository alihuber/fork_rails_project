module OrigEngine
  module Space
    class NamespacedController < OrigEngine::ApplicationController

      def update
        ::OrigEngine::Service.call
      end

    end
  end
end

