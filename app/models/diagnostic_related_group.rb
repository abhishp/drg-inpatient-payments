class DiagnosticRelatedGroup < ApplicationRecord
  validates :definition, presence: true, uniqueness: true, length: {maximum: 4000}

  has_many :drg_provider_details
  has_many :health_care_providers, through: :drg_provider_details
end
