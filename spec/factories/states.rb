FactoryBot.define do
  factory :state do
    sequence :name do |n|
      "State #{n}"
    end
    sequence :abbreviation do |n|
      ('AA'..'ZZ').to_a[n]
    end
  end
end
