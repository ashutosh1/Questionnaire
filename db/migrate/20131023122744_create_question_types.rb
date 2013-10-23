class CreateQuestionTypes < ActiveRecord::Migration
  def change
    create_table :question_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :question_types, :name, :unique => true
  end
end
