class CreateDrgProviderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :drg_provider_details do |t|
      t.integer :total_discharges, null: false
      t.float :average_covered_charges, null: false
      t.float :average_total_payments, null: false
      t.float :average_medicare_payments, null: false

      t.references :health_care_provider, :diagnostic_related_group
      t.timestamps

      t.foreign_key :health_care_providers, on_delete: :cascade
      t.foreign_key :diagnostic_related_groups, on_delete: :cascade
    end
  end
end
