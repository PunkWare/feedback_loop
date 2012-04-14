class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :survey_id
      t.string :title
      t.integer :number_of_choices, { :default => 5 }
      t.string :first_choice, { :default => 'I strongly disagree' }
      t.string :last_choice, { :default => 'I strongly agree' }

      t.timestamps
    end
    add_index :questions, [:survey_id, :created_at]
  end
end
