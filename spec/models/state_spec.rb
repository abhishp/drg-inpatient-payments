require 'rails_helper'

describe State, type: :model do
  describe 'name validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }

    context 'uniqueness' do
      subject { create(:state) }
      it { should validate_uniqueness_of(:name).case_insensitive }
    end
  end

  describe 'abbreviation validations' do
    it { should validate_presence_of(:abbreviation) }
    it { should validate_length_of(:abbreviation).is_equal_to(2) }

    context 'uniqueness' do
      subject { create(:state) }
      it { should validate_uniqueness_of(:abbreviation).case_insensitive }
    end
  end

  context 'on save' do
    it 'should change the case of name to title case' do
      state = create(:state, name: 'SoMe CrAzY CaSeD StAte')

      expect(state.name).to eq('Some Crazy Cased State')
    end

    it 'should change the case of abbreviation to upper case' do
      state = create(:state, abbreviation: 'sS')

      expect(state.abbreviation).to eq('SS')
    end
  end

end