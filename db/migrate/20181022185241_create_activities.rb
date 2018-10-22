class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.string :status
      t.integer :user_id
      t.integer :possibility_id
      t.integer :rating
      t.boolean :exclude, default: false

      t.timestamps
    end
  end
end
