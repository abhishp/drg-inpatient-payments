class CreateHealthCareProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :health_care_providers do |t|
      t.string :name, null: false
      t.string :street, null: false
      t.integer :zip_code, null: false

      t.references :city, :hospital_referral_region
      t.timestamps

      t.foreign_key :cities, on_delete: :cascade
      t.foreign_key :hospital_referral_regions, on_delete: :cascade
    end
  end
end
