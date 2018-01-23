require 'rails_helper'

RSpec.describe DrgProviderDetailsQuery, type: :model do
  context 'validations' do
    subject { build(:drg_provider_details_query) }
    it {should validate_numericality_of(:page).is_greater_than(0).only_integer }

    it {should validate_numericality_of(:page_size).is_greater_than(0).only_integer }

    it {should validate_numericality_of(:min_discharges).is_greater_than_or_equal_to(0).only_integer }
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:min_discharges) }

    it {should validate_numericality_of(:max_discharges)
                   .is_greater_than_or_equal_to(subject.min_discharges)
                   .only_integer.with_message('must be greater than or equal to min_discharges')}
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:max_discharges) }

    it {should validate_numericality_of(:min_average_covered_charges).is_greater_than_or_equal_to(0) }
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:min_average_covered_charges) }

    it {should validate_numericality_of(:max_average_covered_charges)
                   .is_greater_than_or_equal_to(subject.min_average_covered_charges)
                   .with_message('must be greater than or equal to min_average_covered_charges') }
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:max_average_covered_charges) }

    it {should validate_numericality_of(:min_average_medicare_payments).is_greater_than_or_equal_to(0) }
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:min_average_medicare_payments) }

    it {should validate_numericality_of(:max_average_medicare_payments)
                   .is_greater_than_or_equal_to(subject.min_average_medicare_payments)
                   .with_message('must be greater than or equal to min_average_medicare_payments')}
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:max_average_medicare_payments) }

    it {should validate_numericality_of(:min_average_total_payments).is_greater_than_or_equal_to(0) }
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:min_average_total_payments) }

    it {should validate_numericality_of(:max_average_total_payments)
                   .is_greater_than_or_equal_to(subject.min_average_total_payments)
                   .with_message('must be greater than or equal to min_average_total_payments')}
    it {should allow_values(Float::INFINITY, -Float::INFINITY).for(:max_average_total_payments) }

    it 'should allow value of state only within states stored in db' do
      should allow_values(*State.pluck(:abbreviation)).for(:state)
    end

    it 'should not allow value of state not stored db' do
      should_not allow_values('ZZ').for(:state)
    end
  end

  context '#execute' do
    it 'should return nil if query params are invalid' do
      query = DrgProviderDetailsQuery.new(page: -1)

      expect(query).to be_invalid
      expect(query.execute).to be_nil
    end

    it 'should ignore any invalid filter' do
      details = create(:drg_provider_detail)

      query = DrgProviderDetailsQuery.new(foo: :bar)

      expect(query).to be_valid
      expect(query.execute.records.to_a).to eq([details])
    end

    context 'paging' do
      let!(:drg_provider_details) { create_list(:drg_provider_detail, 8) }

      it 'should return the specified page' do
        result = DrgProviderDetailsQuery.new(page: 2, page_size: 5).execute

        expect(result.records.to_a).to eq(drg_provider_details.drop(5))
        expect(result.page).to eq(2)
      end

      it 'should return the specified number of items per page' do
        result = DrgProviderDetailsQuery.new(page: 3, page_size: 2).execute

        expect(result.records.to_a).to eq(drg_provider_details[4..5])
        expect(result.page_size).to eq(2)
      end

      it 'should return the total number of records found for the query' do
        result = DrgProviderDetailsQuery.new(page: 2, page_size: 5).execute

        expect(result.total_record_count).to eq(8)
      end
    end

    context 'state filter' do
      let(:state) { State.first }
      let(:other_state) {create(:state)}

      let(:cities_in_state) { create_list(:city, 5, state: state)}
      let(:city_in_other_state) { create(:city, state: other_state)}

      let(:providers_in_state) { cities_in_state.inject([]) { |providers, city| providers += create_list(:health_care_provider, 2, city: city)} }
      let(:providers_in_other_state) { create_list(:health_care_provider, 2, city: city_in_other_state) }

      let!(:provider_inpatient_details_for_state) do
        providers_in_state.inject([]) do |details, provider|
          details  += create_list(:drg_provider_detail, 2, health_care_provider: provider)
        end
      end
      let!(:provider_inpatient_details_for_other_state) do
        providers_in_other_state.inject([]) do |details, provider|
          details << create(:drg_provider_detail, health_care_provider: provider)
        end
      end

      it 'should filter inpatient payment_details by state' do
        records = DrgProviderDetailsQuery.new(state: state.abbreviation).execute.records.to_a

        expect(records).to eq(state.drg_provider_details)
      end
    end

    context 'total discharges filters' do
      let!(:inpatient_payments_detail_1) { create(:drg_provider_detail, total_discharges: 1) }
      let!(:inpatient_payments_detail_2) { create(:drg_provider_detail, total_discharges: 3) }
      let!(:inpatient_payments_detail_3) { create(:drg_provider_detail, total_discharges: 5) }

      it 'should filter on min_discharges' do
        result = DrgProviderDetailsQuery.new(min_discharges: '2').execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_2, inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to min_discharges value' do
        result = DrgProviderDetailsQuery.new(min_discharges: 5).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on max_discharges' do
        result = DrgProviderDetailsQuery.new(max_discharges: 4).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1, inpatient_payments_detail_2])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to max_discharges value' do
        result = DrgProviderDetailsQuery.new(max_discharges: 1).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on both min_discharges and max_discharges together' do
        result = DrgProviderDetailsQuery.new(min_discharges: '3', max_discharges: '4').execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_2])
        expect(result.total_record_count).to eq(1)
      end

    end

    context 'average covered charges filters' do
      let!(:inpatient_payments_detail_1) { create(:drg_provider_detail, average_covered_charges: 10.1) }
      let!(:inpatient_payments_detail_2) { create(:drg_provider_detail, average_covered_charges: 20.2) }
      let!(:inpatient_payments_detail_3) { create(:drg_provider_detail, average_covered_charges: 30.3) }

      it 'should filter on min_average_covered_charges' do
        result = DrgProviderDetailsQuery.new(min_average_covered_charges: 20.1).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_2, inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to min_average_covered_charges value' do
        result = DrgProviderDetailsQuery.new(min_average_covered_charges: 30.3).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on max_average_covered_charges' do
        result = DrgProviderDetailsQuery.new(max_average_covered_charges: 20.34).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1, inpatient_payments_detail_2])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to max_average_covered_charges value' do
        result = DrgProviderDetailsQuery.new(max_average_covered_charges: 10.1).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on both min_average_covered_charges and max_average_covered_charges together' do
        inpatient_payments_detail = create(:drg_provider_detail, average_covered_charges: 20.1567)

        result = DrgProviderDetailsQuery.new(min_average_covered_charges: '20.1', max_average_covered_charges: '20.3').execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_2, inpatient_payments_detail])
        expect(result.total_record_count).to eq(2)
      end
    end

    context 'average medicare payments filters' do
      let!(:inpatient_payments_detail_1) { create(:drg_provider_detail, average_medicare_payments: 9.12) }
      let!(:inpatient_payments_detail_2) { create(:drg_provider_detail, average_medicare_payments: 18.24) }
      let!(:inpatient_payments_detail_3) { create(:drg_provider_detail, average_medicare_payments: 27.36) }

      it 'should filter on min_average_medicare_payments' do
        result = DrgProviderDetailsQuery.new(min_average_medicare_payments: 18.1).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_2, inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to min_average_medicare_payments value' do
        result = DrgProviderDetailsQuery.new(min_average_medicare_payments: 27.36).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on max_average_medicare_payments' do
        result = DrgProviderDetailsQuery.new(max_average_medicare_payments: 20.42).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1, inpatient_payments_detail_2])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to max_average_medicare_payments value' do
        result = DrgProviderDetailsQuery.new(max_average_medicare_payments: 9.12).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on both min_average_medicare_payments and max_average_medicare_payments together' do
        inpatient_payments_detail = create(:drg_provider_detail, average_medicare_payments: 20.1567)

        result = DrgProviderDetailsQuery.new(min_average_medicare_payments: '20.1', max_average_medicare_payments: '30.3').execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_3, inpatient_payments_detail])
        expect(result.total_record_count).to eq(2)
      end
    end

    context 'average total payments filters' do
      let!(:inpatient_payments_detail_1) { create(:drg_provider_detail, average_total_payments: 9.12) }
      let!(:inpatient_payments_detail_2) { create(:drg_provider_detail, average_total_payments: 18.24) }
      let!(:inpatient_payments_detail_3) { create(:drg_provider_detail, average_total_payments: 27.36) }

      it 'should filter on min_average_total_payments' do
        result = DrgProviderDetailsQuery.new(min_average_total_payments: 18.1).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_2, inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to min_average_total_payments value' do
        result = DrgProviderDetailsQuery.new(min_average_total_payments: 27.36).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_3])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on max_average_total_payments' do
        result = DrgProviderDetailsQuery.new(max_average_total_payments: 20.42).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1, inpatient_payments_detail_2])
        expect(result.total_record_count).to eq(2)
      end

      it 'should include the records with total discharges equal to max_average_total_payments value' do
        result = DrgProviderDetailsQuery.new(max_average_total_payments: 9.12).execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_1])
        expect(result.total_record_count).to eq(1)
      end

      it 'should filter on both min_average_total_payments and max_average_total_payments together' do
        inpatient_payments_detail = create(:drg_provider_detail, average_total_payments: 20.1567)

        result = DrgProviderDetailsQuery.new(min_average_total_payments: '20.1', max_average_total_payments: '30.3').execute

        expect(result.records.to_a).to eq([inpatient_payments_detail_3, inpatient_payments_detail])
        expect(result.total_record_count).to eq(2)
      end
    end

    context 'associations' do
      it 'should include all associations when state and hospital referral region is in fields' do
        stubbed_fields_helper = double(DrgProviderDetailFields)
        expect(stubbed_fields_helper).to receive(:include_state?).and_return(true)
        expect(stubbed_fields_helper).to receive(:include_hospital_referral_region?).and_return(true)
        query = DrgProviderDetailsQuery.new({}, stubbed_fields_helper)

        query.execute

        expect(query.instance_variable_get("@associations")).to eq({health_care_provider: [{city: :state}, :hospital_referral_region]})
      end

      it 'should include health_care_provider, city and state associations when state is in fields and hospital referral region is not in fields' do
        stubbed_fields_helper = double(DrgProviderDetailFields)
        expect(stubbed_fields_helper).to receive(:include_state?).twice.and_return(true)
        expect(stubbed_fields_helper).to receive(:include_hospital_referral_region?).and_return(false)
        query = DrgProviderDetailsQuery.new({}, stubbed_fields_helper)

        query.execute

        expect(query.instance_variable_get("@associations")).to eq({health_care_provider: {city: :state}})
      end

      it 'should include health_care_provider, city and hospital_referral_region associations when city and hospital referral region is in fields and state is not included' do
        stubbed_fields_helper = double(DrgProviderDetailFields)
        expect(stubbed_fields_helper).to receive(:include_state?).twice.and_return(false)
        expect(stubbed_fields_helper).to receive(:include_hospital_referral_region?).and_return(true)
        expect(stubbed_fields_helper).to receive(:include_city?).and_return(true)
        query = DrgProviderDetailsQuery.new({}, stubbed_fields_helper)

        query.execute

        expect(query.instance_variable_get("@associations")).to eq({health_care_provider: [:hospital_referral_region, :city]})
      end

      it 'should include health_care_provider and hospital_referral_region associations when hospital referral region is in fields and state and city are not included' do
        stubbed_fields_helper = double(DrgProviderDetailFields)
        expect(stubbed_fields_helper).to receive(:include_state?).twice.and_return(false)
        expect(stubbed_fields_helper).to receive(:include_hospital_referral_region?).and_return(true)
        expect(stubbed_fields_helper).to receive(:include_city?).and_return(false)
        query = DrgProviderDetailsQuery.new({}, stubbed_fields_helper)

        query.execute

        expect(query.instance_variable_get("@associations")).to eq({health_care_provider: [:hospital_referral_region]})
      end

      it 'should include health_care_provider and city associations when both state and hospital referral region are not in fields and city is in fields' do
        stubbed_fields_helper = double(DrgProviderDetailFields)
        expect(stubbed_fields_helper).to receive(:include_state?).twice.and_return(false)
        expect(stubbed_fields_helper).to receive(:include_hospital_referral_region?).and_return(false)
        expect(stubbed_fields_helper).to receive(:include_city?).and_return(true)
        query = DrgProviderDetailsQuery.new({}, stubbed_fields_helper)

        query.execute

        expect(query.instance_variable_get("@associations")).to eq({health_care_provider: :city})
      end

      it 'should include health_care_provider association when all city, state and hospital referral region are not in fields and provider fields are present' do
        stubbed_fields_helper = double(DrgProviderDetailFields)
        expect(stubbed_fields_helper).to receive(:include_state?).twice.and_return(false)
        expect(stubbed_fields_helper).to receive(:include_hospital_referral_region?).and_return(false)
        expect(stubbed_fields_helper).to receive(:include_city?).and_return(false)
        expect(stubbed_fields_helper).to receive(:include_provider?).and_return(true)
        query = DrgProviderDetailsQuery.new({}, stubbed_fields_helper)

        query.execute

        expect(query.instance_variable_get("@associations")).to eq(:health_care_provider)
      end

      it 'should not include any association when all city, state, provider fields and hospital referral region are not in fields' do
        stubbed_fields_helper = double(DrgProviderDetailFields)
        expect(stubbed_fields_helper).to receive(:include_state?).twice.and_return(false)
        expect(stubbed_fields_helper).to receive(:include_hospital_referral_region?).and_return(false)
        expect(stubbed_fields_helper).to receive(:include_city?).and_return(false)
        expect(stubbed_fields_helper).to receive(:include_provider?).and_return(false)
        query = DrgProviderDetailsQuery.new({}, stubbed_fields_helper)

        query.execute

        expect(query.instance_variable_get("@associations")).to be_nil
      end
    end
  end
end