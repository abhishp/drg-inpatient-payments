require 'rails_helper'
require Rails.root.join('lib', 'csv_data_seeder')
require 'tempfile'

RSpec.describe CSVDataSeeder do
  let(:valid_csv_line) { "039 - SOME DRG DEFINITION,1,PROVIDER NAME,PROVIDER'S ADDRESS,City 1,AA,12345,AA - City 1,91,$32963.07,$5777.24,$4763.73" }
  let(:invalid_csv_line) {"039 - SOME DRG DEFINITION,2,OTHER PROVIDER NAME,OTHER PROVIDER'S ADDRESS,City X,ZZ,12345,ZZ - City X,91,3296.07,577.24,763.73"}

  setup { create(:state, abbreviation: 'AA') }

  it 'should import data correctly' do
    csv_data_seeder = CSVDataSeeder.new(csv_file(valid_csv_line))
    csv_data_seeder.seed

    expect(csv_data_seeder.successfully_processed_record_count).to eq(1)
    expect(csv_data_seeder.erroneous_record_count).to be_zero
  end

  it 'should correctly record erroneous records' do
    expect(Rails.logger).to receive(:error).with("State not found for #{invalid_csv_line}")

    csv_data_seeder = CSVDataSeeder.new(csv_file(invalid_csv_line))
    csv_data_seeder.seed

    expect(csv_data_seeder.successfully_processed_record_count).to be_zero
    expect(csv_data_seeder.erroneous_record_count).to eq(1)
  end

  it 'should return total number of records processed' do
    csv_data_seeder = CSVDataSeeder.new(csv_file(valid_csv_line, invalid_csv_line))
    csv_data_seeder.seed

    expect(csv_data_seeder.successfully_processed_record_count).to eq(1)
    expect(csv_data_seeder.erroneous_record_count).to eq(1)
    expect(csv_data_seeder.total_records).to eq(2)
  end

  private

  def csv_file(*csv_lines)
    data_file = Tempfile.open('data_file', Rails.root.join('tmp')) do |file|
      file.puts("DRG Definition,Provider Id,Provider Name,Provider Street Address,Provider City,Provider State,Provider Zip Code,Hospital Referral Region Description, Total Discharges , Average Covered Charges , Average Total Payments ,Average Medicare Payments")
      csv_lines.each { |csv_line| file.puts(csv_line) }
      file
    end
    InpatientPaymentsCSVFile.new(data_file.path)
  end
end