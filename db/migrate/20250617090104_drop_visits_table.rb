class DropVisitsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :visits do |t|
      t.integer :count
      t.string :page_name
      t.timestamps
    end
  end
end
