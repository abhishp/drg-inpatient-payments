require 'rails_helper'

RSpec.describe DrgProviderDetailFields do
  context 'validity' do
    let(:invalid_fields) { ['some_random_field', :other_random_field, 'anotherRandomField']}
    let(:valid_fields) { DrgProviderDetailFields::ALL_FIELDS }

    it 'should be invalid when any invalid field is present in fields' do
      fields = DrgProviderDetailFields.new(invalid_fields + valid_fields)

      expect(fields).not_to be_valid
      expect(fields.errors[:some_random_field]).to eq(['is not a valid field'])
      expect(fields.errors[:other_random_field]).to eq(['is not a valid field'])
      expect(fields.errors[:another_random_field]).to eq(['is not a valid field'])
    end

    it 'should be valid for all valid fields' do
      fields = DrgProviderDetailFields.new(valid_fields)

      expect(fields).to be_valid
    end

    it 'should accept fields in camel case format' do
      fields = DrgProviderDetailFields.new(['providerState', 'providerZipCode', :providerName])

      expect(fields).to be_valid
    end

    it 'should accept fields in snake case format' do
      fields = DrgProviderDetailFields.new(['provider_state', 'provider_zip_code', :provider_name])

      expect(fields).to be_valid
    end
  end

  context '#include_state?' do
    it 'should return true when fields include provider_state' do
      expect(DrgProviderDetailFields.new([:provider_state]).include_state?).to be_truthy
    end

    it 'should return false when fields do not include provider_state' do
      expect(DrgProviderDetailFields.new([:provider_city]).include_state?).to be_falsey
    end
  end

  context '#include_hospital_referral_region?' do
    it 'should return true when fields include hospital_referral_region_description' do
      expect(DrgProviderDetailFields.new([:hospital_referral_region_description]).include_hospital_referral_region?).to be_truthy
    end

    it 'should return false when fields do not include hospital_referral_region_description' do
      expect(DrgProviderDetailFields.new([:provider_state]).include_hospital_referral_region?).to be_falsey
    end
  end

  context '#include_city?' do
    it 'should return true when fields include provider_city or provider_state or both' do
      expect(DrgProviderDetailFields.new([:provider_city]).include_city?).to be_truthy
      expect(DrgProviderDetailFields.new([:provider_state]).include_city?).to be_truthy
      expect(DrgProviderDetailFields.new([:provider_city, :provider_state]).include_city?).to be_truthy
    end

    it 'should return false when fields do not include both provider_city and provider_state' do
      expect(DrgProviderDetailFields.new([:provider_name]).include_city?).to be_falsey
    end
  end

  context '#include_provider?' do
    it 'should return true when any provider field is present in fields' do
      expect(DrgProviderDetailFields.new([:provider_name]).include_provider?).to be_truthy
      expect(DrgProviderDetailFields.new([:provider_street_address]).include_provider?).to be_truthy
      expect(DrgProviderDetailFields.new([:provider_zip_code]).include_provider?).to be_truthy
      expect(DrgProviderDetailFields.new([:provider_city]).include_provider?).to be_truthy
      expect(DrgProviderDetailFields.new([:provider_state]).include_provider?).to be_truthy
    end

    it 'should return true when fields include hospital_referral_region_description' do
      expect(DrgProviderDetailFields.new([:hospital_referral_region_description]).include_provider?).to be_truthy
    end

    it 'should return false when none of the provider fields or hospital_referral_region_description is in fields' do
      expect(DrgProviderDetailFields.new([:total_discharges]).include_provider?).to be_falsey
    end
  end

  context '#included' do
    it 'should return sub array of fields present' do
      fields = DrgProviderDetailFields.new([:provider_state, :provider_zip_code, :provider_name])

      expect(fields.included(:provider_city, :provider_name, :provider_street_address, :provider_state))
          .to eq([:provider_state, :provider_name])
    end
  end

  context '#include?' do
    it 'should return return true when given field is present' do
      fields = DrgProviderDetailFields.new([:provider_state, :provider_zip_code, :provider_name])

      expect(fields.include?(:provider_name)).to be_truthy
      expect(fields.include?(:provider_state)).to be_truthy
      expect(fields.include?(:provider_zip_code)).to be_truthy
    end

    it 'should return return false when given field is not present' do
      fields = DrgProviderDetailFields.new([:provider_state, :provider_zip_code, :provider_name])

      expect(fields.include?(:provider_city)).to be_falsey
      expect(fields.include?(:provider_street_address)).to be_falsey
    end
  end
end