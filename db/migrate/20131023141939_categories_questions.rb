class CategoriesQuestions < ActiveRecord::Migration
  def change
    create_table :categories_questions do |t|
      t.references :question, :null => false
      t.references :category, :null => false

      t.timestamps
    end
    add_index :categories_questions, [:category_id, :question_id]
  end
end
