# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  has_many :line_items, as: :container, dependent: :destroy

  enum status: { ordered: 0, paid: 1, cancelled: 2, completed: 3 }

  scope :of, ->(user) { where(user: user).order(:created_at) }
  scope :with, ->(status) { status != :all ? where(status: status) : self }

  after_create_commit :update_total_price

  def update_total_price
    update(total_price: line_items.includes(:item).sum(&:sub_total))
  end
end
