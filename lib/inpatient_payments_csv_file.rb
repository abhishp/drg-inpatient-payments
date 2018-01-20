class InpatientPaymentsCSVFile
  REQUIRED_HEADERS = [:drg_definition, :provider_id, :provider_name, :provider_street_address, :provider_city,
                      :provider_state, :provider_zip_code, :hospital_referral_region_description, :total_discharges,
                      :average_covered_charges, :average_total_payments, :average_medicare_payments]

  attr_reader :path, :errors

  def initialize(path)
    @path = path || ''
    @errors = []
  end

  def valid?
    validate_file && validate_headers
    @errors.empty?
  end

  private

  def validate_headers
    headers = File.open(@path, &:readline).chomp
    headers = headers.split(',').map {|header| header.gsub(/\s|\n/, '').underscore.to_sym }
    header_missing = REQUIRED_HEADERS.any? {|header| !headers.include?(header)}
    @errors << "Given CSV file (#{@path}) is not compatible." if header_missing
    !header_missing
  end

  def validate_file
    file_exists = File.exists?(@path)
    @errors << 'Specified CSV file path is invalid.' unless file_exists
    file_exists
  end

end
