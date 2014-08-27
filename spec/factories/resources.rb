FactoryGirl.define do
  factory :resource, class: Ichabod::ResourceSet::Resource do
    skip_create
    prefix 'prefix'
    sequence :identifier do |n| ["identifier-#{n}"] end
    sequence :title do |n| ["Title #{n}"] end
  end
end
