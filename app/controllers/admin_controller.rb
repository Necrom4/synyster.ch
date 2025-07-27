class AdminController < ApplicationController
  include FilteredTraffic
  before_action :require_secret_key

  def db_check
    begin
      filtered_visit = filter_visits.sort_by { |visit| -visit.id }.first(100)
      filtered_event = filter_events.sort_by { |event| -event.id }.first(100)

      all_data = ActiveRecord::Base.descendants.each_with_object({}) do |model, hash|
        next if model.abstract_class? || !model.table_exists?

        begin
          hash[model.name] = model.order(id: :desc).limit(100)
        rescue
          next
        end
      end

      output_data = {
        "Filtered Visits" => filtered_visit,
        "Filtered Events" => filtered_event
      }.merge(all_data)

      render json: output_data
    rescue *DB_ERRORS => e
      render json: "Skipped DB-check due to database error: #{e.class} - #{e.message}"
    end
  end

  private

  def require_secret_key
    unless params[:key] == ENV["ADMIN_KEY"]
      render plain: "Access denied", status: :unauthorized
    end
  end
end
