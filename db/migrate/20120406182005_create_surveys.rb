class CreateSurveys < ActiveRecord::Migration
  def change
    create_table    :surveys do |t|
        t.integer   :user_id
        t.string    :title
        t.string    :key
        t.boolean   :available, default: false
        t.boolean   :anonymous, default: false
        t.boolean   :private, default: false
        t.string    :link
        t.integer   :order

        t.timestamps
    end
     add_index :surveys, [:user_id, :available, :created_at]
     add_index :surveys, [:key]
     add_index :surveys, [:created_at]
  end
end
