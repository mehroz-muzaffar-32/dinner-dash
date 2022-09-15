# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :item
  belongs_to :container, polymorphic: true

  validates :quantity_ordered, presence: true, numericality: { greater_than: 0 }

  def sub_total
    quantity_ordered * item.price
  end
end
