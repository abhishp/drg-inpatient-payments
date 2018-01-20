class DollarConverter
  def self.convert(value)
    return value if Float === value
    value.sub('$', '').to_f
  end
end