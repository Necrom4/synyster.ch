class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true

  serialize :properties, coder: JSON

  scope :filtered, -> {
    where(visit_id: Ahoy::Visit.filtered)
      .or(Ahoy::Event.where(
        visit_id: Ahoy::Event.group(:visit_id).having("COUNT(*) > 1").select(:visit_id)
      ))
  }
end
