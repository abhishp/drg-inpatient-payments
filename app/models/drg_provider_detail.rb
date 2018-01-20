class DrgProviderDetail < ApplicationRecord
  validates :average_covered_charges, :average_medicare_payments, :average_total_payments,
            numericality: true, presence: true
  validates :total_discharges, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :health_care_provider
  belongs_to :diagnostic_related_group
end
