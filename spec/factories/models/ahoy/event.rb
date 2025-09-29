FactoryBot.define do
  factory :ahoy_event, class: "Ahoy::Event" do
    association :visit, factory: :ahoy_visit
  end
end
