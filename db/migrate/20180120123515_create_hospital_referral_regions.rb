class CreateHospitalReferralRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_referral_regions do |t|
      t.string :description, null: false, limit: 100
      t.timestamps
    end

    reversible do |direction|
      direction.up { add_unique_constraint(:hospital_referral_regions, :description) }
      direction.down { drop_unique_constraint(:hospital_referral_regions, :description) }
    end
  end
end
