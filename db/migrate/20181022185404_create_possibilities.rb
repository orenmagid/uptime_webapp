class CreatePossibilities < ActiveRecord::Migration[5.2]
  def change
    create_table :possibilities do |t|
      t.string :name
      t.string :description
      t.string :past_tense
      t.integer :physical_intensity
      t.integer :mental_intensity
      t.integer :fun_index
      t.integer :duration_in_minutes
      t.boolean :others_required

      t.timestamps
    end
  end
end
