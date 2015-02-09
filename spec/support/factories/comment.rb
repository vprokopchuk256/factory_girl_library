FactoryGirl.define do
  factory :comment do
    title 'Some Interesting title'
    association :post
  end
end