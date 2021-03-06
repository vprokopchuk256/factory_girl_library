require 'rails/all'
require 'rspec/rails'
require 'rspec/its'
require 'active_record'
require 'factory_girl_library'
require 'pry-byebug'

require 'coveralls'
Coveralls.wear!

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

if ActiveRecord::Base.respond_to?(:raise_in_transactional_callbacks) 
  ActiveRecord::Base.raise_in_transactional_callbacks = true
end

ActiveRecord::Base.after_rollback { |record| FactoryGirlLibrary::Library.reload(record) }

Post = Class.new(ActiveRecord::Base)

Comment = Class.new(ActiveRecord::Base) do
  belongs_to :post
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include DB
  
  config.before :all do
    ::ActiveRecord::Base.remove_connection if ::ActiveRecord::Base.connected?

    ActiveRecord::Base.establish_connection(adapter: "mysql2", 
                                            database: "library_test_db", 
                                            username: "root")
  end   

  config.before :all do
    db.create_table(:posts) do |t|
      t.string :title
    end unless db.table_exists?(:posts)

    db.create_table(:comments) do |t|
      t.string :title
      t.integer :post_id
    end unless db.table_exists?(:comments)
  end

end
