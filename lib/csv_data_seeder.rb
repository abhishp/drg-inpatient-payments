require 'converters/dollar_converter'
require 'inpatient_payments_csv_file'
require 'smarter_csv'

class CSVDataSeeder
  CSV_OPTIONS = {
      chunk_size: 100,
      value_converters: {
          average_covered_charges: DollarConverter,
          average_total_payments: DollarConverter,
          average_medicare_payments: DollarConverter
      }
  }

  attr_reader :successfully_processed_record_count, :erroneous_record_count

  def initialize(inpatient_csv_file)
    @csv_file  = inpatient_csv_file
    @successfully_processed_record_count = 0
    @erroneous_record_count = 0
    @state_cache = Caching::StateCache.new
    @hospital_referral_region = {}
    @cities = {}
    @health_care_providers = {}
    @diagnostic_related_groups = {}
  end

  def total_records
    @successfully_processed_record_count + @erroneous_record_count
  end

  def seed
    SmarterCSV.process(@csv_file.path, CSV_OPTIONS) do |chunk|
      chunk.each do |record|
        begin
          process(record)
          @successfully_processed_record_count += 1
        rescue => e
          Rails.logger.error(e.message + ' for ' + record.values.join(','))
          @erroneous_record_count += 1
        end
      end
      puts "Processed #{@successfully_processed_record_count + @erroneous_record_count} records from csv"
    end
  end

  private


  def state(abbreviation)
    @state_cache.get_by_abbreviation(abbreviation)
  end

  def city(record)
    state = state(record[:provider_state])
    raise 'State not found' unless state
    @cities[record[:hospital_referral_region_description].downcase] ||= state.cities.find_or_create_by(name: record[:provider_city])
  end

  def hospital_referral_region(record)
    region_code = record[:hospital_referral_region_description]
    @hospital_referral_region[region_code.downcase] ||= HospitalReferralRegion.find_or_create_by(description: region_code)
  end

  def health_care_provider(record)
    @health_care_providers[record[:provider_id]] ||= HealthCareProvider.find_or_create_by(id: record[:provider_id],
                                                                                          name: record[:provider_name],
                                                                                          zip_code: record[:provider_zip_code],
                                                                                          street: record[:provider_street_address],
                                                                                          city: city(record),
                                                                                          hospital_referral_region: hospital_referral_region(record))
  end

  def diagnostic_related_group(record)
    @diagnostic_related_groups[record[:drg_definition].downcase] ||= DiagnosticRelatedGroup.find_or_create_by(definition: record[:drg_definition])
  end

  def process(record)
    DrgProviderDetail.create(diagnostic_related_group: diagnostic_related_group(record),
                             health_care_provider: health_care_provider(record),
                             average_covered_charges: record[:average_covered_charges],
                             average_medicare_payments: record[:average_medicare_payments],
                             average_total_payments: record[:average_total_payments],
                             total_discharges: record[:total_discharges])
  end

end