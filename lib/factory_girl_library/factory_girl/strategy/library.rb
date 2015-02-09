module FactoryGirlLibrary
  module FactoryGirl
    module Strategy
      class Library < ::FactoryGirl::Strategy::Create
        def association runner
          runner.run(:library)
        end

        def result(evaluation)
          factory_name = ::FactoryGirl::Factory.last_run_factory

          unless FactoryGirlLibrary::Library.registered?(factory_name) 
            Thread.new{ FactoryGirlLibrary::Library.register(factory_name, super(evaluation)) }.join
          end

          FactoryGirlLibrary::Library.get(factory_name)
        end     
      end
    end
  end
end

