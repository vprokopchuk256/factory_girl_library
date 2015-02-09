require 'factory_girl_library/library'

module FactoryGirlLibrary
  module FactoryGirl
    module FactoryGirlClassDecorator
      def library(name, opts = {})
        super name

        FactoryGirlLibrary::Library.get(name, opts)
      end
    end
  end
end