require 'rails_helper'

RSpec.describe HospitalReferralRegion, type: :model do
  context 'description validations' do
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_most(100).is_at_least(3) }

    context 'uniqueness' do
      subject { create(:hospital_referral_region) }
      it {should validate_uniqueness_of(:description).case_insensitive }
    end
  end

  context 'associations' do
    it 'should delete all associated health care providers when referral region is deleted' do
      referral_region = create(:hospital_referral_region)
      create_list(:health_care_provider, 5, hospital_referral_region: referral_region)

      expect(HealthCareProvider.where(hospital_referral_region: referral_region)).not_to be_empty

      referral_region.destroy

      expect(HealthCareProvider.where(hospital_referral_region: referral_region)).to be_empty
    end
  end
end
