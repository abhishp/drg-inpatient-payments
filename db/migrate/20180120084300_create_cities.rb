class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name, limit: 50, null: false
      t.integer :state_id, null: false

      t.index :state_id
      t.foreign_key :states, on_delete: :cascade
    end
  end
end
