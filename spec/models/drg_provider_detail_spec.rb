require 'rails_helper'

RSpec.describe DrgProviderDetail, type: :model do
  context 'average_covered_charges validations' do
    it { should validate_presence_of(:average_covered_charges) }
    it { should validate_numericality_of(:average_covered_charges) }
  end

  context 'average_medicare_payments validations' do
    it { should validate_presence_of(:average_medicare_payments) }
    it { should validate_numericality_of(:average_medicare_payments) }
  end

  context 'average_total_payments validations' do
    it { should validate_presence_of(:average_total_payments) }
    it { should validate_numericality_of(:average_total_payments) }
  end

  context 'total_discharges validations' do
    it { should validate_presence_of(:total_discharges) }
    it { should validate_numericality_of(:total_discharges).only_integer.is_greater_than(0) }
  end
end
