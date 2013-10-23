class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.references :question, :null => false
      t.text :option
      t.boolean :answer

      t.timestamps
    end
    add_index :options, :answer
  end
end
