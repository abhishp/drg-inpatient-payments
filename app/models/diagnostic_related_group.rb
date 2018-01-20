class DiagnosticRelatedGroup < ApplicationRecord
  validates :definition, presence: true, uniqueness: true, length: {maximum: 4000}
end
