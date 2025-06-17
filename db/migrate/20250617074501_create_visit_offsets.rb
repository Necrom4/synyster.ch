class CreateVisitOffsets < ActiveRecord::Migration[8.0]
  def change
    create_table :visit_offsets do |t|
      t.integer :base_count

      t.timestamps
    end
  end
end
