class CreateTestSets < ActiveRecord::Migration
  def change
    create_table :test_sets do |t|
      t.string :number
      t.string :name
      t.text :instruction

      t.timestamps
    end
    add_index :test_sets, :name
    add_index :test_sets, :number
  end
end
