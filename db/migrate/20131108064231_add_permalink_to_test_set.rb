class AddPermalinkToTestSet < ActiveRecord::Migration
  def self.up
    add_column :test_sets, :permalink, :string
    add_index :test_sets, :permalink
  end
  def self.down
    remove_column :test_sets, :permalink
  end
end