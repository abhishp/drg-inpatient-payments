class DrgProviderDetailFields
  PROVIDER_FIELDS = [:provider_name, :provider_street_address, :provider_zip_code]
  ALL_FIELDS = PROVIDER_FIELDS + [:provider_city, :provider_state, :hospital_referral_region_description, :total_discharges,
                                  :average_covered_charges, :average_medicare_payments, :average_total_payments]

  delegate :include?, to: :@fields

  attr_reader :errors

  def initialize(fields=[])
    @fields = fields.present? ? fields.map(&:to_s).map(&:underscore).map(&:to_sym) : ALL_FIELDS
    @errors = {}
  end

  def valid?
    validate
    @errors.empty?
  end

  def include_state?
    @fields.include?(:provider_state)
  end

  def include_hospital_referral_region?
    @fields.include?(:hospital_referral_region_description)
  end

  def include_city?
    @fields.include?(:provider_city) || include_state?
  end

  def include_provider?
    PROVIDER_FIELDS.any? { |field| @fields.include?(field) } || include_city? || include_state? || include_hospital_referral_region?
  end

  def included(*fields)
    (@fields & fields)
  end

  private

  def validate
    @fields.each do |field|
      @errors[field] = { error: :is_not_valid_field } unless  ALL_FIELDS.include?(field)
    end
  end
end