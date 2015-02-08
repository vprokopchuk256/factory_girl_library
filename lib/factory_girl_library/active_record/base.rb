require 'factory_girl_library/library'

class ActiveRecord::Base
  after_rollback { |record| FactoryGirlLibrary::Library.reload(record) }
end