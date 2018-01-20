class City < ApplicationRecord
  include BeforeSaveMethods::TitleizeName

  validates :name, presence: true, length: {in: 3..50}

  belongs_to :state
  has_many :health_care_providers, dependent: :delete_all

  before_save :titleize_name
end
