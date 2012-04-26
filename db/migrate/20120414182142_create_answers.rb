class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :user_id
      t.integer :choice
      t.text :comment

      t.timestamps
    end
    add_index :answers, [:question_id, :user_id], unique: true
    add_index :answers, [:question_id, :choice]
  end
end
