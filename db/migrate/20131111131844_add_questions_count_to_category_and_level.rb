class AddQuestionsCountToCategoryAndLevel < ActiveRecord::Migration
  def change
  	add_column :categories, :questions_count, :integer, :default => 0
  	add_column :question_levels, :questions_count, :integer, :default => 0
  end
end
