class QuestionsTestSets < ActiveRecord::Migration
  def change
    create_table :questions_test_sets, :id => false do |t|
      t.references :test_set, :null => false
      t.references :question, :null => false
    end
    add_index :questions_test_sets, [:test_set_id, :question_id]
  end
end
