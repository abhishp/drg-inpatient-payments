require 'rails_helper'
require File.join(Rails.root, 'lib', 'converters', 'dollar_converter')

RSpec.describe DollarConverter do
  it 'should convert string starting with $ to float' do
    expect(DollarConverter.convert('$567.89')).to eq(567.89)
  end

  it 'should return floating point number as it is' do
    float = 567.89

    expect(DollarConverter.convert(float)).to equal(float)
  end

end