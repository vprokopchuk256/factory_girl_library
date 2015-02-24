require 'rspec/core'
require 'factory_girl'

require 'factory_girl_library/railtie'
require 'factory_girl_library/factory_girl/factory_decorator'
require 'factory_girl_library/factory_girl/syntax/methods_decorator'
require 'factory_girl_library/factory_girl/factory_girl_class_decorator'
require 'factory_girl_library/factory_girl/strategy/library'
require 'factory_girl_library/library'

FactoryGirl::Factory.send(:prepend, FactoryGirlLibrary::FactoryGirl::FactoryDecorator)
FactoryGirl.register_strategy(:library, FactoryGirlLibrary::FactoryGirl::Strategy::Library)
FactoryGirl.send(:extend, FactoryGirlLibrary::FactoryGirl::FactoryGirlClassDecorator)
FactoryGirl::Syntax::Methods.send(:prepend, FactoryGirlLibrary::FactoryGirl::Syntax::MethodsDecorator)

RSpec.configure do |config|
    config.around :each do |test|
      if use_transactional_fixtures != false
        self.use_transactional_fixtures = false

        ::ActiveRecord::Base.connection.transaction(isolation: :read_committed) do
          test.run
          raise ::ActiveRecord::Rollback
        end

        self.use_transactional_fixtures = true
      else
        test.run
      end
    end

    config.after :all do
      FactoryGirlLibrary::Library.clear
    end
end