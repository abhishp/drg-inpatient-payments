FactoryBot.define do
  factory :diagnostic_related_group do
    sequence :definition do |n|
      "#{n.to_s.rjust(3, '0')} - EXTRACRANIAL PROCEDURES W/O CC/MCC"
    end
  end
end
