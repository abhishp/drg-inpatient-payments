json.providerName health_care_provider.name
json.providerStreetAddress health_care_provider.street
json.partial! 'cities/show', city: health_care_provider.city
json.providerZipCode health_care_provider.zip_code
json.partial!('hospital_referral_regions/show', hospital_referral_region: health_care_provider.hospital_referral_region)
