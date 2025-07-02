class AdminController < ApplicationController
  include FilteredVisit
  before_action :require_secret_key

  def db_check
    all_data = ActiveRecord::Base.descendants.each_with_object({}) do |model, hash|
      next if model.abstract_class? || !model.table_exists?
      begin
        hash[model.name] = model.order(id: :desc).limit(100)
      rescue
        next
      end
    end

    filtered_visit = filter_visits.sort_by { |visit| -visit.id }.first(100)

    all_data["Ahoy::Visit (filtered)"] = filtered_visit

    render json: all_data
  end

  private

  def require_secret_key
    unless params[:key] == ENV["ADMIN_KEY"]
      render plain: "Access denied", status: :unauthorized
    end
  end
end
