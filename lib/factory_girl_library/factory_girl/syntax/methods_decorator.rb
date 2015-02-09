module FactoryGirlLibrary
  module FactoryGirl
    module Syntax
      module MethodsDecorator
        def library name, opts
          ::FactoryGirl.library(name, opts)
        end
      end
    end
  end
end