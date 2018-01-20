class City < ApplicationRecord
  include BeforeSaveMethods::TitleizeName
  belongs_to :state

  validates :name, presence: true, length: {in: 3..50}

  before_save :titleize_name
end
