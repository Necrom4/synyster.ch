class AdminController < ApplicationController
  before_action :require_secret_key

  def db_check
    all_data = ActiveRecord::Base.descendants.each_with_object({}) do |model, hash|
      next if model.abstract_class? || !model.table_exists?
      begin
        hash[model.name] = model.all.limit(100)
      rescue
        next
      end
    end

    filtered_visits = Ahoy::Visit.limit(100).select do |visit|
      !bot_visit?(visit) && !blocked_country?(visit.country)
    end

    all_data["Ahoy::Visit (filtered)"] = filtered_visits

    render json: all_data
  end

  private

  def require_secret_key
    unless params[:key] == ENV["ADMIN_KEY"]
      render plain: "Access denied", status: :unauthorized
    end
  end

  def bot_visit?(visit)
    user_agent = visit.user_agent.to_s.downcase
    browser = Browser.new(user_agent)
    browser.bot? || user_agent.include?("headless") || visit.ip == "::1"
  end

  def blocked_country?(country)
    %w[IN RO RU US].include?(country)
  end
end
