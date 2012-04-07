class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :user_id
      t.string :title
      t.string :key

      t.timestamps
    end
    add_index :surveys, [:user_id, :title]
    add_index :surveys, [:key]
  end
end
