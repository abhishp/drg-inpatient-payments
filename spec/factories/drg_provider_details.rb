FactoryBot.define do
  factory :drg_provider_detail do
    total_discharges 91
    average_covered_charges 32963.07
    average_total_payments 5777.24
    average_medicare_payments 4763.73

    health_care_provider
    diagnostic_related_group
  end
end
