class State < ApplicationRecord
  validates :name, presence: true, uniqueness: {case_sensitive: false}, length: {in: 3..50}

  validates :abbreviation, presence: true, uniqueness: {case_sensitive: false}, length: {is: 2}

  before_save :titleize_name, :make_abbreviation_upper_case

  private

  def titleize_name
    self.name = self.name.downcase.titlecase
  end

  def make_abbreviation_upper_case
    self.abbreviation = self.abbreviation.upcase
  end

end