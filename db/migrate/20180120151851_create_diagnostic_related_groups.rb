class CreateDiagnosticRelatedGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :diagnostic_related_groups do |t|
      t.string :definition, null: false

      t.timestamps
    end

    reversible do |direction|
      direction.up { add_unique_constraint(:diagnostic_related_groups, :definition) }
      direction.down { drop_unique_constraint(:diagnostic_related_groups, :definition) }
    end
  end
end
