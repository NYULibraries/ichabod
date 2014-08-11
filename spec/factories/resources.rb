FactoryGirl.define do
  factory :resource, class: Ichabod::ResourceSet::Resource do
    skip_create
    sequence :identifier do |n| "prefix:id-#{n}" end
    sequence :title do |n| "Title #{n}" end
  end
end
