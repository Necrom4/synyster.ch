class AdminController < ApplicationController
  before_action :require_secret_key

  def db_tables_snapshot
    render json: DbTablesSnapshot.call
  end

  private

  def require_secret_key
    unless params[:key] == ENV["ADMIN_KEY"]
      render plain: "Access denied", status: :unauthorized
    end
  end
end
