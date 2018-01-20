require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'name validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
  end

  context 'associations' do
    it 'should delete all health_care_providers when the city is deleted' do
      city = create(:city)
      create_list(:health_care_provider, 5, city: city)

      expect(HealthCareProvider.where(city: city)).not_to be_empty

      city.destroy

      expect(HealthCareProvider.where(city: city)).to be_empty
    end
  end
end
