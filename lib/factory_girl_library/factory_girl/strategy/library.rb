module FactoryGirlLibrary
  module FactoryGirl
    module Strategy
      class Library
        def association(runner)
          runner.run
        end

        def result(evaluation)
          FactoryGirlLibrary::Library.create(::FactoryGirl::Factory.last_run_factory, evaluation.hash)
        end     
      end
    end
  end
end

