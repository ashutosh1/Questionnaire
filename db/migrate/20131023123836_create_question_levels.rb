class CreateQuestionLevels < ActiveRecord::Migration
  def change
    create_table :question_levels do |t|
      t.string :name

      t.timestamps
    end
    add_index :question_levels, :name, :unique => true
  end
end
