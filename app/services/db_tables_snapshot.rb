class DbTablesSnapshot
  def self.call
    all_tables = ActiveRecord::Base.descendants.each_with_object({}) do |model, hash|
      next if model.abstract_class? || !model.table_exists?

      begin
        hash[model.name] = model.order(id: :desc)
      rescue
        next
      end
    end

    filtered_visits = Ahoy::Visit.filtered.sort_by { |visit| -visit.id }
    filtered_events = Ahoy::Event.filtered.sort_by { |event| -event.id }

    {
      "Filtered Visits" => filtered_visits,
      "Filtered Events" => filtered_events
    }.merge(all_tables)
  rescue *DB_ERRORS => e
    { "error" => "Skipped DbTablesSnapshot.call due to database error: #{e.class} - #{e.message}" }
  end
end
