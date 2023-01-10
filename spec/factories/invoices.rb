FactoryBot.define do
  factory :invoice do
    transient do
      invoice_item_status { nil }
      transaction_result { nil }
    end

    association :customer

    factory :invoice_with_invoice_item do
      after(:create) do |invoice, evaluator|
        create(:invoice_item, invoice_id: invoice.id, status: evaluator.invoice_item_status)
      end
    end

    factory :invoice_with_transaction do
      after(:create) do |invoice, evaluator|
        create(:transaction, invoice_id: invoice.id, result: evaluator.transaction_result)
      end
    end
  end
end
