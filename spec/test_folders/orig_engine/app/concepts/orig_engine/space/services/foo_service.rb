module OrigEngine
  class Space < ActiveRecord::Base
    module Services
      class FooService
        def call
          name = case object
            when OrigEngine::Foo then "Foo"
            when OrigEngine::Bar then "Bar"
            when OrigEngine::Qux then "Qux"
            else
              raise ArgumentError
            end
          if name
            OrigEngineMailer.deliver("OrigEngine::Mail::#{name}", object)
          end
        end
      end
    end
  end
end
