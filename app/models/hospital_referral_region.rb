class HospitalReferralRegion < ApplicationRecord
  validates :description, uniqueness: {case_sensitive: false}, presence: true, length: {in: 3..100}

  has_many :health_care_providers, dependent: :delete_all
end
