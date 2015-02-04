module FactoryGirlLibrary
  module FactoryGirl
    module Strategy
      class Library
        def initialize
          @strategy = ::FactoryGirl.strategy_by_name(:create).new
        end

        delegate :association, to: :@strategy

        def result(evaluation)
          @strategy.result(evaluation)
        end
      end     
    end
  end
end

