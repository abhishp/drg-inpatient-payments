require 'rails_helper'

describe HospitalReferralRegion, type: :model do
  context 'description validations' do
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_most(100).is_at_least(3) }

    context 'uniqueness' do
      subject { create(:hospital_referral_region) }
      it {should validate_uniqueness_of(:description).case_insensitive }
    end
  end
end
