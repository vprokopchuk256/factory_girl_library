module Mv
  module Core
    class Railtie < ::Rails::Railtie
      initializer "factory_girl_library.initialize", after: '"active_record.set_configs"' do
        class ::ActiveRecord::Base 
          after_rollback { |record| FactoryGirlLibrary::Library.reload(record) }
        end
      end
    end
  end
end