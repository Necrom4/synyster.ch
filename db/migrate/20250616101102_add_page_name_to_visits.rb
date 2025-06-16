class AddPageNameToVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :visits, :page_name, :string
  end
end
