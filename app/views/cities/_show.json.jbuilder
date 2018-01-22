if @fields.include?(:provider_city)
  json.provider_city city.name
end

if @fields.include_state?
  json.partial! 'states/show', state: city.state
end
