require 'smarter_csv'
require_relative '../csv_data_seeder'

namespace :csv do
  desc "Seed data from csv"
  task :seed, [:csv_file_path] => :environment do |_, args|
    ActiveRecord::Base.logger.level = Logger::ERROR
    csv_file = InpatientPaymentsCSVFile.new(args.csv_file_path)
    raise 'Invalid Inpatient Payments CSV file' unless csv_file.valid?

    csv_data_seeder = CSVDataSeeder.new(csv_file)
    start_time = Time.now
    csv_data_seeder.seed
    time_taken = Time.now-start_time

    puts "================================================================================"
    puts "                                 CSV DATA SEEDER                                "
    puts "================================================================================"
    puts "Successful record migrations: #{csv_data_seeder.successfully_processed_record_count}"
    puts "Erroneous record migrations: #{csv_data_seeder.erroneous_record_count}"
    puts "Total Time Taken: #{time_taken} seconds"
    puts "Average Time / Record: #{time_taken/csv_data_seeder.total_records}"
    puts "================================================================================"
  end
end