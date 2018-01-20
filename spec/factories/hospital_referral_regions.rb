FactoryBot.define do
  factory :hospital_referral_region do
    sequence :description do |n|
      "#{('AA'..'ZZ').to_a[n]} - Winterfell"
    end
  end
end
