FactoryBot.define  do
  factory :drg_provider_details_query do
    min_discharges { Random.rand(100) }
    min_average_covered_charges { Random.rand * Random.rand(99) }
    min_average_medicare_payments { Random.rand * Random.rand(99) }
    min_average_total_payments { Random.rand * Random.rand(99) }
  end
end