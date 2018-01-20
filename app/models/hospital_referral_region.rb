class HospitalReferralRegion < ApplicationRecord
  validates :description, uniqueness: {case_sensitive: false}, presence: true, length: {in: 3..100}
end
