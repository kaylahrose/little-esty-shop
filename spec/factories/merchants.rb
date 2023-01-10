FactoryBot.define do
  factory :merchant do
    sequence(:name, 0) { |n| "Merchant#{n}"}

    factory :merchant_with_item do
      after(:create) do |cust|
        create(:item)
      end
    end
  end
end
