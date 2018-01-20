require 'rails_helper'
require Rails.root.join('lib', 'inpatient_payments_csv_file')
require 'tempfile'

RSpec.describe InpatientPaymentsCSVFile do
  context 'validity' do
    let(:required_headers) { ["DRG Definition", "Provider Id", "Provider Name", "Provider Street Address",
                              "Provider City", "Provider State", "Provider Zip Code", "Average Total Payments",
                              "Hospital Referral Region Description", "Total Discharges", "Average Covered Charges",
                              "Average Medicare Payments"] }

    it 'should add error if the csv file path is invalid' do
      csv_file = InpatientPaymentsCSVFile.new('some_random_file.csv')

      expect(csv_file.valid?).to be_falsey
      expect(csv_file.errors).to include('Specified CSV file path is invalid.')
    end

    context 'CSV headers' do

      it 'should add error when all required headers are not present' do
        required_headers.each do |header|
          invalid_headers = required_headers - [header]
          data_file = Tempfile.open('data_csv', Rails.root.join('tmp')) do |file|
            file.puts(invalid_headers.join(','))
            file
          end
          csv_file = InpatientPaymentsCSVFile.new(data_file.path)

          expect(csv_file.valid?).to be_falsey
          expect(csv_file.errors).to include("Given CSV file (#{data_file.path}) is not compatible.")
        end
      end

      it 'should not add error when all required headers are present' do
        data_file = Tempfile.open('data_csv', Rails.root.join('tmp')) do |file|
          file.puts(required_headers.join(','))
          file
        end

        csv_file = InpatientPaymentsCSVFile.new(data_file.path)

        expect(csv_file.valid?).to be_truthy
        expect(csv_file.errors).to be_empty
      end

    end

  end
end