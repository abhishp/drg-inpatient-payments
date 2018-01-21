module Validators
  class NumericFilterValidator < ActiveModel::Validations::NumericalityValidator
    def validate_each(record, attr_name, value)
      return if options[:allow_infinity] && value.respond_to?(:infinite?) && value.infinite?

      super
    end
  end
end
