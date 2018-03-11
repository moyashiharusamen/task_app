class Task < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  enum status: { todo: 0, doing: 1, done: 2 }
  enum priority: { low: 0, middle: 1, high: 2 }

  SORTABLE_COLUMNS = %w[name description expires_at created_at priority].freeze
  SORTABLE_ORDERS = %w[asc desc].freeze

  scope :order_by, -> (column, order) {
    sort_column = column.in?(SORTABLE_COLUMNS) ? column : "created_at"
    sort_order = order.in?(SORTABLE_ORDERS) ? order : "desc"

    order(sort_column => sort_order)
  }

  scope :search_by_name, -> (name) {
    if name.present?
      where(['name like ?', "%#{sanitize_sql_like(name)}%"])
    else
      all
    end
  }
  scope :search_by_status, -> (status) {
    if status.present?
      where(status: status)
    else
      all
    end
  }
end
