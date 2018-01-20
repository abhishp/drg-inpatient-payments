class State < ApplicationRecord
  include BeforeSaveMethods::TitleizeName

  validates :name, presence: true, uniqueness: {case_sensitive: false}, length: {in: 3..50}
  validates :abbreviation, presence: true, uniqueness: {case_sensitive: false}, length: {is: 2}

  before_save :titleize_name, :make_abbreviation_upper_case

  has_many :cities, dependent: :delete_all

  private

  def make_abbreviation_upper_case
    self.abbreviation = self.abbreviation.upcase
  end

end