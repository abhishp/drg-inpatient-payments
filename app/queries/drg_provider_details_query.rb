class DrgProviderDetailsQuery
  include ActiveModel::Validations
  INTEGER_FILTERS = [:page, :page_size, :min_discharges, :max_discharges]
  FLOAT_FILTERS = [
      :min_average_covered_charges, :max_average_covered_charges,
      :min_average_medicare_payments, :max_average_medicare_payments,
      :min_average_total_payments, :max_average_total_payments
  ]
  VALID_FILTERS = [:state] + INTEGER_FILTERS + FLOAT_FILTERS

  DEFAULTS = {
      page: 1,
      page_size: 30,
      min_discharges: -Float::INFINITY,
      min_average_covered_charges: -Float::INFINITY,
      min_average_medicare_payments: -Float::INFINITY,
      min_average_total_payments: -Float::INFINITY,
      max_discharges: Float::INFINITY,
      max_average_covered_charges: Float::INFINITY,
      max_average_medicare_payments: Float::INFINITY,
      max_average_total_payments: Float::INFINITY
  }

  QueryParams = Struct.new(*VALID_FILTERS)

  validates :page, :page_size, numericality: {only_integer: true, greater_than: 0}

  validates_with Validators::NumericFilterValidator, attributes: [:min_discharges],
                 only_integer: true, greater_than_or_equal_to: 0, allow_infinity: true

  validates_with Validators::NumericFilterValidator,
                 attributes: [:min_average_covered_charges, :min_average_medicare_payments, :min_average_total_payments],
                 greater_than_or_equal_to: 0, allow_infinity: true

  validates_with Validators::NumericFilterValidator, attributes: [:max_discharges],
                 greater_than_or_equal_to: :min_discharges, allow_infinity: true, only_integer: true,
                 message: 'must be greater than or equal to min_discharges'

  validates_with Validators::NumericFilterValidator, attributes: [:max_average_covered_charges],
                 greater_than_or_equal_to: :min_average_covered_charges, allow_infinity: true,
                 message: 'must be greater than or equal to min_average_covered_charges'

  validates_with Validators::NumericFilterValidator, attributes: [:max_average_medicare_payments],
                 greater_than_or_equal_to: :min_average_medicare_payments, allow_infinity: true,
                 message: 'must be greater than or equal to min_average_medicare_payments'

  validates_with Validators::NumericFilterValidator, attributes: [:max_average_total_payments],
                 greater_than_or_equal_to: :min_average_total_payments, allow_infinity: true,
                 message: 'must be greater than or equal to min_average_total_payments'

  validates :state, format: {with: /\A[A-Z]{2}\z/}, allow_blank: true, allow_nil: true,
            inclusion: {in: State.pluck(:abbreviation)}

  VALID_FILTERS.each do |filter|
    delegate filter, "#{filter}=", to: :@query_params
  end

  def initialize(query_params = {}, fields_helper = DrgProviderDetailFields.new)
    @query_params = QueryParams.new(*parse_values_for_filters(query_params.symbolize_keys))
    @relation = DrgProviderDetail.all
    @fields = fields_helper
  end

  def execute
    return unless valid?
    build
    QueryResult.new(@relation.paginate(page: page, per_page: page_size), @relation.count, page, page_size)
  end

  private

  def parse_values_for_filters(query_params)
    VALID_FILTERS.map do |filter|
      value = query_params[filter]
      if value.blank?
        DEFAULTS[filter]
      elsif INTEGER_FILTERS.include?(filter)
        value.to_s.to_i
      elsif FLOAT_FILTERS.include?(filter)
        value.to_s.to_f
      else
        value
      end
    end
  end

  def build
    build_query
    build_associations
  end

  def build_query
    for_state
    with_total_discharges
    with_average_covered_charges
    with_average_medicare_payments
    with_average_total_payments
  end

  def for_state
    return @relation if self.state.blank?

    @relation = State.find_by_abbreviation(self.state).drg_provider_details
  end

  # def add_numeric_comparison_clause(attribute)
  #   min_attribute_value = self.send("min_#{attribute}".to_sym)
  #   max_attribute_value = self.send("max_#{attribute}".to_sym)
  #   return relation if min_attribute_value.infinite? && max_attribute_value.infinite?
  #
  #   filter_params = {}
  #   filter_params[attribute] = min_attribute_value..max_attribute_value
  #   relation.where(filter_params)
  # end

  def with_total_discharges
    return if min_discharges.to_f.infinite? && max_discharges.to_f.infinite?

    @relation = @relation.where(total_discharges: min_discharges..max_discharges)
  end

  def with_average_covered_charges
    return if min_average_covered_charges.infinite? && max_average_covered_charges.infinite?

    @relation = @relation.where(average_covered_charges: min_average_covered_charges..max_average_covered_charges)
  end

  def with_average_medicare_payments
    return if min_average_medicare_payments.infinite? && max_average_medicare_payments.infinite?

    @relation = @relation.where(average_medicare_payments: min_average_medicare_payments..max_average_medicare_payments)
  end

  def with_average_total_payments
    return if min_average_total_payments.infinite? && max_average_total_payments.infinite?

    @relation = @relation.where(average_total_payments: min_average_total_payments..max_average_total_payments)
  end

  def build_associations
    @associations = if @fields.include_state? && @fields.include_hospital_referral_region?
                      {health_care_provider: [{city: :state}, :hospital_referral_region]}
                    elsif @fields.include_state?
                      {health_care_provider: {city: :state}}
                    elsif @fields.include_hospital_referral_region?
                      dependencies = [:hospital_referral_region]
                      dependencies << :city if @fields.include_city?
                      {health_care_provider: dependencies}
                    elsif @fields.include_city?
                      {health_care_provider: :city}
                    elsif @fields.include_provider?
                      :health_care_provider
                    else
                      nil
                    end
    return unless @associations

    @relation = @relation.includes(@associations)
  end

end
