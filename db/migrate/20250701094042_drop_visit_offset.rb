class DropVisitOffset < ActiveRecord::Migration[8.0]
  def change
    drop_table :visit_offsets
  end
end
