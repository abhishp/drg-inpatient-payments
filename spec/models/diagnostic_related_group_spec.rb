require 'rails_helper'

RSpec.describe DiagnosticRelatedGroup, type: :model do
  context 'definition validations' do
    it { should validate_presence_of(:definition) }
    it { should validate_length_of(:definition).is_at_most(4000) }

    context 'uniqueness' do
      subject { create(:diagnostic_related_group) }
      it { should validate_uniqueness_of(:definition) }
    end
  end
end
