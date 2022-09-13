# frozen_string_literal: true

class Item < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  belongs_to :restaurant
  has_many :line_items, dependent: :nullify
end
