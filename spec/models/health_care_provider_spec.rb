require 'rails_helper'

RSpec.describe HealthCareProvider, type: :model do
  context 'name validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  end

  describe 'zip code validations' do
    it { should validate_presence_of(:zip_code) }
    it { should validate_numericality_of(:zip_code)
                    .only_integer
                    .is_less_than_or_equal_to(99999) }
  end

  describe 'street validations' do
    it {should validate_presence_of(:street) }
    it {should validate_length_of(:street).is_at_most(4000) }
  end
end
