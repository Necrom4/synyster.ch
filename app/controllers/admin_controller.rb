class AdminController < ApplicationController
  include FilteredVisit
  before_action :require_secret_key

  def db_check
    # Step 1: Compute filtered visits
    filtered_visit = filter_visits.sort_by { |visit| -visit.id }.first(100)
    filtered_visit_ids = filtered_visit.map(&:id)

    # Step 2: Find Ahoy::Event records with visit_id in filtered_visit_ids
    matching_events = Ahoy::Event.where(visit_id: filtered_visit_ids)

    # Step 3: Group events by visit_id
    grouped_events = matching_events.group_by(&:visit_id)

    # Step 4: Select only those groups where there are multiple events
    duplicated_event_groups = grouped_events.select { |_visit_id, events| events.size > 1 }

    # Flatten the selected groups back into an array
    filtered_events = duplicated_event_groups.values.flatten

    # Step 5: Collect all data from other models
    all_data = ActiveRecord::Base.descendants.each_with_object({}) do |model, hash|
      next if model.abstract_class? || !model.table_exists?

      begin
        case model.name
        when "Ahoy::Visit"
          hash[model.name] = model.order(id: :desc).limit(100)
        when "Ahoy::Event"
          hash[model.name] = filtered_events
        else
          hash[model.name] = model.order(id: :desc).limit(100)
        end
      rescue
        next
      end
    end

    # Step 6: Add filtered_visit at the beginning
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
