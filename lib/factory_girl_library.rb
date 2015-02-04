require 'rspec/core'
require 'factory_girl'

require 'factory_girl_library/factory_girl/strategy/library'

FactoryGirl.register_strategy(:library, FactoryGirlLibrary::FactoryGirl::Strategy::Library)

RSpec.configure do |config|
  config.around :each do |test|
    test.run
  end
end