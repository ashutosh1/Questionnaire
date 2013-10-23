class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.references :question_type, :null => false
      t.references :question_level, :null => false
      t.references :user, :null => false

      t.timestamps
    end
    add_index :questions, :user_id
    add_index :questions, :question_type_id
    add_index :questions, :question_level_id
  end
end
