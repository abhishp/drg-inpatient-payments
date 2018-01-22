if @fields.include?(:provider_name)
  json.provider_name health_care_provider.name
end

if @fields.include?(:provider_street_address)
  json.provider_street_address health_care_provider.street
end

if @fields.include_city?
  json.partial! 'cities/show', city: health_care_provider.city
end

if @fields.include?(:provider_zip_code)
  json.provider_zip_code health_care_provider.zip_code
end

if @fields.include_hospital_referral_region?
  json.partial! 'hospital_referral_regions/show', hospital_referral_region: health_care_provider.hospital_referral_region
end
