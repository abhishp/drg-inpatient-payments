class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :abbreviation, null: false, limit: 2
      t.string :name, null: false, limit: 50
    end
    reversible do |direction|
      direction.up { add_unique_constraint(:states, :abbreviation, :name) }
      direction.down { drop_unique_constraint(:states, :abbreviation, :name) }
    end

  end
end
