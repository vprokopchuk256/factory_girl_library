require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

ENV["COVERAGE"] && SimpleCov.start do
  add_filter "/.rvm/"
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

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

Post = Class.new(ActiveRecord::Base)

Comment = Class.new(ActiveRecord::Base) do
  belongs_to :post
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include DB
  config.use_transactional_fixtures = false
  
  config.before :all do
    ::ActiveRecord::Base.remove_connection if ::ActiveRecord::Base.connected?

    ActiveRecord::Base.establish_connection(adapter: "mysql2", 
                                            database: "library_test_db", 
                                            username: "root")
  end   

  config.before :each do
    db.drop_table(:posts) if db.table_exists?(:posts) 
    db.create_table(:posts) do |t|
      t.string :title
    end

    db.drop_table(:comments) if db.table_exists?(:comments) 
    db.create_table(:comments) do |t|
      t.string :title
      t.integer :post_id
    end

    FactoryGirlLibrary::Library.clear
  end
end
