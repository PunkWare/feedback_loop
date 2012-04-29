class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer :user_id
      t.integer :survey_id

      t.timestamps
    end
    add_index :accesses, [:survey_id, :user_id], unique: true
  end
end
