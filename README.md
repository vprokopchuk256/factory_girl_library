# !!!Is under development!!!

# Factories can be fast

Personally I love [Rspec](https://github.com/rspec/rspec) and [FactoryGirl](https://github.com/thoughtbot/factory_girl). Both libraries are very eloquent and very comfortable to use. Especially when one writes tests following [best practices](http://betterspecs.org/).

But there is a problem there. Single expectation tests means a lot of tests. Huge suite sometimes. And many tests need some data that should be created. That takes a lot of time and makes suite unbearable long. 

```factory_girl_library``` is a library based on top of [FactoryGirl](https://github.com/thoughtbot/factory_girl) that allows to load frequently used instances into the memory and then reuse that from there without recreating each time data is required. 

That makes your tests faster. That is especially significant when complex objects with many assosiations are created. 

# How it works

```factory_girl_library``` defines [FactoryGirl](https://github.com/thoughtbot/factory_girl) custom strategy ```library``` that in turn creates & memorize requested instance first time, and then access cached version. 

Example: 

Let's assume that we have ```Post``` factory defined:

```ruby
FactoryGirl.define do
  factory :post do
    is_interesting true
    is_usefull true
  end
end
```

then ```post``` instance will be created once only below:

```ruby

describe 'interesting Post instance behavior' do
  let(:post) { FactoryGirl.library(:post) }

  it 'is interesting' do
    expect(post).to be_interesting
  end

  it 'is usefull' do
    expect(post).to be_usefull
  end
end

```

```factory_girl_library``` allows developer to modify instance attributes for the test being. All such changes will be reverted after each test: 

```ruby
describe 'not interesting Post instance behavior' do
  let(:post) { FactoryGirl.library(:post, is_interesting: false) }

  it 'is NOT interesting' do
    expect(post).not_to be_interesting
  end

  it 'is usefull' do
    expect(post).to be_usefull
  end
end

describe 'once more interesting Post instance behavior' do
  let(:post) { FactoryGirl.library(:post) }

  it 'is interesting' do
    expect(post).to be_interesting
  end
end
```

That is important to understand that library internally stores original object instance without additional parameters are applied and only after that applies custom attributes to already cached object version

After each test object is reverted back in the database ( db transaction is responsible for that ) and reloaded into the memory after that. So ```factory_girl_library``` takes care of db and memory object synchronization. 

Also ```after :all``` hook is defined internally. It destroys all objects that were created by the tests.

# Installation

In Gemfile: 

```
  gem 'factory_firl_library'
```

# When you should use it

* You have bunch of simple tests that creates data examples internally 
* You are trying to make test as atomic as possible. 
  So one object instance is described / used in the most of your test cases.  

# When you should NOT use it

* ```SQLite``` is NOT supported. 
  ```MySQL``` and ```PostgreSQL``` ARE supported. 

* Integration tests
  Internally ```factory_girl_library``` requires transaction to rollback to the original data that is not a case for integration tests where dedicated connection is used usually. You still can use it for non integration tests. 

* Test that requires transactions with the isolation level other than :read_committed
  The reason for that is simple. Internally ```factory_girl_library``` runs tests in the transaction with isolation_level == :read_committed and internal transactions with different isolation level are not allowed. 

# Known issues

If you are using Rails 4 you could see warning message like this: 

```
DEPRECATION WARNING: Currently, Active Record suppresses errors raised within `after_rollback`/`after_commit` callbacks and only print them to the logs. In the next version, these errors will no longer be suppressed. Instead, the errors will propagate normally just like in other Active Record callbacks.

You can opt into the new behavior and remove this warning by setting:

  config.active_record.raise_in_transactional_callbacks = true
```

You could see that message because ```factory_girl_library``` uses ```after_rollback``` hook for data synchronization. 

That warning message could be easily suppressed as described [here](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#error-handling-in-transaction-callbacks).

## Version History

**(1.0.0)** (27 Feb, 2015)

* First version

## Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


