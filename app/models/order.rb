# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  has_many :line_items, as: :container, dependent: :destroy

  enum status: { ordered: 0, paid: 1, cancelled: 2, completed: 3 }

  scope :of, ->(user) { where(user: user).order(:created_at) }
  scope :with, ->(status) { status && status != 'all' ? where(status: status) : self }

  def total_price
    sum = 0
    line_items.each do |line_item|
      sum += line_item.sub_total
    end
    sum
  end
end
