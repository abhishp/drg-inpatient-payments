class DrgProviderDetailsController < ApplicationController

  def index
    query = DrgProviderDetailsQuery.new(search_params.to_h)
    if query.valid?
      query_result = query.execute
      @drg_provider_details = query_result.records
      response.set_header('X-Total-Record-Count', query_result.total_record_count)
      response.set_header('X-Page-Number', query_result.page)
      response.set_header('X-Page-Size', query_result.page_size)
    else
      render status: :bad_request
    end
  end

  private

  def search_params
    params.permit(:page, :page_size, :state,
                  :max_discharges, :min_discharges,
                  :max_average_covered_charges, :min_average_covered_charges,
                  :max_average_medicare_payments, :min_average_medicare_payments,
                  :max_average_total_payments, :min_average_total_payments)
  end
end
