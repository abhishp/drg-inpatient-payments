FactoryBot.define do
  factory :health_care_provider do
    sequence :name do |n|
      "Health Care Provider #{n}"
    end

    sequence :street do |n|
      "#{n} King's Landing, Westeros"
    end

    zip_code 12345

    city
    hospital_referral_region
  end
end
