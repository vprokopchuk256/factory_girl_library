require 'rspec/core'
require 'factory_girl'

require 'factory_girl_library/factory_girl/factory_decorator'
require 'factory_girl_library/factory_girl/syntax/methods_decorator'
require 'factory_girl_library/factory_girl/factory_girl_class_decorator'
require 'factory_girl_library/factory_girl/strategy/library'
require 'factory_girl_library/active_record/base'
require 'factory_girl_library/library'

FactoryGirl::Factory.send(:prepend, FactoryGirlLibrary::FactoryGirl::FactoryDecorator)
FactoryGirl.register_strategy(:library, FactoryGirlLibrary::FactoryGirl::Strategy::Library)
FactoryGirl.send(:extend, FactoryGirlLibrary::FactoryGirl::FactoryGirlClassDecorator)
FactoryGirl::Syntax::Methods.send(:prepend, FactoryGirlLibrary::FactoryGirl::Syntax::MethodsDecorator)

RSpec.configure do |config|
  config.around :each do |test|
    test.run
  end

  config.after :all do
    FactoryGirlLibrary::Library.clear
  end
end