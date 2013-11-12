class AddTypeToQuestion < ActiveRecord::Migration
  def up
  	remove_column :questions, :question_type_id 
  	add_column :questions, :type, :string
  	add_index :questions, :type
  end

  def down
  	add_column :questions, :question_type_id, :integer
  	remove_column :questions, :type
  end
end
