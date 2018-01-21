class DrgProviderDetailsController < ApplicationController

  def index
    @drg_provider_details = DrgProviderDetail.includes(health_care_provider: [{city: :state}, :hospital_referral_region])
                                .paginate(page: params[:page], per_page: params[:page_size])
  end

  private

  def search_params
    params.permit(:page, :page_size, :state,
                  :max_discharges, :min_discharges,
                  :max_average_covered_charges, :min_average_covered_charges,
                  :max_average_medicare_payments, :min_average_medicare_payments)
  end
end
