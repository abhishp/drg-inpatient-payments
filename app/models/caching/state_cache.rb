module Caching
  class StateCache
    def initialize
      @states_by_abbreviation = {}
    end

    def get_by_abbreviation(state_abbreviation)
      init_abbreviation_cache if @states_by_abbreviation.empty?
      @states_by_abbreviation[state_abbreviation.downcase]
    end

    private

    def init_abbreviation_cache
      @states_by_abbreviation = State.all.inject({}) do |cache, state|
        cache[state.abbreviation.downcase] = state
        cache
      end
    end
  end
end