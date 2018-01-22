if @fields.include_provider?
  json.partial! 'health_care_providers/show', health_care_provider: drg_provider_detail.health_care_provider
end


json.(drg_provider_detail, *@fields.included(:total_discharges, :average_covered_charges, :average_medicare_payments,
                                             :average_total_payments))
