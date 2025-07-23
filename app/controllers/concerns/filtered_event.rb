module FilteredEvent
  include FilteredVisit
  extend ActiveSupport::Concern

  private

  def filter_events
    # 1. Get the filtered visit IDs
    filtered_visit_ids = filter_visits.map(&:id)

    # 2. Events matching filtered visits
    visit_filtered_events = Ahoy::Event.where(visit_id: filtered_visit_ids)

    # 3. Events where visit_id appears more than once (in full table)
    duplicate_visit_ids = Ahoy::Event
      .group(:visit_id)
      .having("COUNT(*) > 1")
      .pluck(:visit_id)

    duplicated_event_groups = Ahoy::Event.where(visit_id: duplicate_visit_ids)

    # 4. Combine both, deduplicate, sort, and limit
    (visit_filtered_events + duplicated_event_groups)
      .uniq { |event| event.id }
      .sort_by { |event| -event.id }
      .first(100)
  end
end
