class AdminController < ApplicationController
  include FilteredVisit
  before_action :require_secret_key

  def db_check
    # Step 1: Get the filtered Ahoy::Visit records
    filtered_visit = filter_visits.sort_by { |visit| -visit.id }.first(100)
    filtered_visit_ids = filtered_visit.map(&:id)

    # Step 2: Get events with visit_id in filtered_visit_ids
    visit_filtered_events = Ahoy::Event.where(visit_id: filtered_visit_ids)

    # Step 3: Get all events with visit_id that appears multiple times across entire Ahoy::Event table
    duplicate_visit_ids = Ahoy::Event
      .group(:visit_id)
      .having("COUNT(*) > 1")
      .pluck(:visit_id)

    duplicated_event_groups = Ahoy::Event.where(visit_id: duplicate_visit_ids)

    # Step 4: Combine and deduplicate both sets, then sort by id descending
    combined_events = (visit_filtered_events + duplicated_event_groups)
      .uniq { |event| event.id }
      .sort_by { |event| -event.id }
      .first(100) # Limit output to 100

    # Step 5: Load all other tables
    all_data = ActiveRecord::Base.descendants.each_with_object({}) do |model, hash|
      next if model.abstract_class? || !model.table_exists?

      begin
        case model.name
        when "Ahoy::Visit"
          hash[model.name] = model.order(id: :desc).limit(100)
        when "Ahoy::Event"
          hash[model.name] = combined_events
        else
          hash[model.name] = model.order(id: :desc).limit(100)
        end
      rescue
        next
      end
    end

    # Step 6: Insert the filtered Ahoy::Visit results at the top
    output_data = { "Ahoy::Visit (filtered)" => filtered_visit }.merge(all_data)

    render json: output_data
  end

  private

  def require_secret_key
    unless params[:key] == ENV["ADMIN_KEY"]
      render plain: "Access denied", status: :unauthorized
    end
  end
end
