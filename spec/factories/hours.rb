FactoryGirl.define do
  factory :hour do
    project
    category
    description ""
    value 1
    starting_time "2014-02-26 08:00"
    user

    factory :hour_with_client do
      project { create(:project, client: create(:client)) }
    end
  end
end
