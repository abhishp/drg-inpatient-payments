class HealthCareProvider < ApplicationRecord
  validates :name, presence: true, length: {in: 3..100}
  validates :zip_code, presence: true,
            numericality: {only_integer: true, less_than_or_equal_to: 99999 }
  validates :street, presence: true, length: {maximum: 4000}

  belongs_to :city
  belongs_to :hospital_referral_region
  has_many :drg_provider_details
  has_many :diagnostic_related_groups, through: :drg_provider_details
end
