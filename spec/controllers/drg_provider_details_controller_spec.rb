require 'rails_helper'

RSpec.describe DrgProviderDetailsController, type: :controller do
  render_views

  context '#index' do
    it 'should use DrgProviderDetailsQuery to fetch records' do
      expect_any_instance_of(DrgProviderDetailsQuery).to receive(:valid?).and_return(true)
      expect_any_instance_of(DrgProviderDetailsQuery).to receive(:execute).and_return(QueryResult.new([], 0, 1, 30))

      get :index, format: :json

      expect(response.status).to eq(200)
    end

    context 'valid request' do
      it 'should render the json array for' do
        drg_provider_details = create_list(:drg_provider_detail, 5)

        get :index, format: :json

        providers = JSON.parse(response.body, symbolize_names: true)
        expect(response).to render_template('drg_provider_details/index')
        expect(assigns(:drg_provider_details).to_a).to eq(drg_provider_details)
        expect(providers.map {|provider| provider[:providerName]}).to eq(drg_provider_details.collect(&:health_care_provider).collect(&:name))
      end

      it 'should render all health care provider fields by default' do
        health_care_provider = create(:drg_provider_detail).health_care_provider

        get :index, format: :json

        provider = JSON.parse(response.body, symbolize_names: true).first
        expect(provider[:providerName]).to eq(health_care_provider.name)
        expect(provider[:providerStreetAddress]).to eq(health_care_provider.street)
        expect(provider[:providerCity]).to eq(health_care_provider.city.name)
        expect(provider[:providerState]).to eq(health_care_provider.city.state.abbreviation)
        expect(provider[:providerZipCode]).to eq(health_care_provider.zip_code)
        expect(provider[:hospitalReferralRegionDescription]).to eq(health_care_provider.hospital_referral_region.description)
      end

      it 'should render all payments fields by default' do
        drg_provider_detail = create(:drg_provider_detail)

        get :index, format: :json

        provider = JSON.parse(response.body, symbolize_names: true).first
        expect(provider[:totalDischarges]).to eq(drg_provider_detail.total_discharges)
        expect(provider[:averageCoveredCharges]).to eq(drg_provider_detail.average_covered_charges)
        expect(provider[:averageMedicarePayments]).to eq(drg_provider_detail.average_medicare_payments)
        expect(provider[:averageTotalPayments]).to eq(drg_provider_detail.average_total_payments)
      end

      it 'should render only given fields when fields param is given' do
        provider = create(:drg_provider_detail).health_care_provider

        get :index, format: :json, params: {:fields => %w(providerName providerState)}

        provider_details = JSON.parse(response.body, symbolize_names: true).first

        expect(response.status).to eq(200)
        expect(provider_details).to eq({providerName: provider.name, providerState: provider.city.state.abbreviation})
      end

      it 'should render only given field' do
        create(:drg_provider_detail).health_care_provider

        DrgProviderDetailFields::ALL_FIELDS.each do |field|
          field = field.to_s.camelize(:lower)

          get :index, format: :json, params: {'fields[]' => field }

          provider_details = JSON.parse(response.body).first
          expect(response.status).to eq(200)
          expect(provider_details.keys).to eq([field])
        end
      end
    end

    context 'invalid request' do
      it 'should return status as bad request when query params are wrong' do
        get :index, format: :json, params: {page: -1}

        expect(response.status).to eq(400)
      end

      it 'should return status as bad request when fields params are invalid' do
        get :index, format: :json, params: {'fields[]' =>  'blah'}

        expect(response.status).to eq(400)
      end
    end

    context 'pagination' do
      let!(:drg_provider_details) { create_list(:drg_provider_detail, 8) }

      it 'should fetch the given page number' do
        get :index, format: :json, params: {page: 2, page_size: 5}

        actual_provider_details = assigns(:drg_provider_details).to_a
        expect(actual_provider_details.size).to eq(3)
        expect(actual_provider_details).to eq(drg_provider_details.drop(5))
      end

      it 'should override page size' do
        get :index, format: :json, params: {page: 3, page_size: 2}

        actual_provider_details = assigns(:drg_provider_details).to_a
        expect(actual_provider_details.size).to eq(2)
        expect(actual_provider_details).to eq(drg_provider_details[4..5])
      end

      it 'should add pagination metadata in response headers' do
        get :index, format: :json, params: {page: 3, page_size: 2}

        expect(response.get_header('X-Total-Record-Count')).to eq(8)
        expect(response.get_header('X-Page-Number')).to eq(3)
        expect(response.get_header('X-Page-Size')).to eq(2)
      end

    end
  end

end
