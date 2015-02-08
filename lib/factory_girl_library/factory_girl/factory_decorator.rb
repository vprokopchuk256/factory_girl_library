module FactoryGirlLibrary
  module FactoryGirl
    module FactoryDecorator
      @@last_run_factory = nil

      def self.prepended(mod) 
        mod.send(:extend, ClassMethods)
      end

      def run *args
        self.class.last_run_factory = name
        super(*args)
      end

      module ClassMethods
        def last_run_factory= factory_name
          @last_run_factory = factory_name
        end

        def last_run_factory
          @last_run_factory
        end
      end

    end
  end
end