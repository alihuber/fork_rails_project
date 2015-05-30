module FancyAppCore
  module Namespace
    class NamespacedController < FancyAppCore::ApplicationController
      def update
        ::FancyAppCore::Service.call
        redirect_to fancy_engine_core.namespace_index_path
      end
    end
  end
end
