require 'rails_helper'

RSpec.describe StatesController, type: :controller do
  render_views

  context '#index' do
    let(:states) { State.all }
    it 'should render all states as json' do
      get :index, format: :json

      actual_states = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(200)
      expect(actual_states).to eq(states.map { |state| {name: state.name, abbreviation: state.abbreviation } })
    end
  end
end
