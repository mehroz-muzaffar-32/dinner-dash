# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :restaurant

  has_many :line_items, dependent: :nullify
  has_many :categories_items, dependent: :destroy
  has_many :categories, through: :categories_items

  has_one_attached :photo

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :categories, presence: true

  enum status: { not_retired: 0, retired: 1 }

  scope :of, ->(category) { eager_load(:categories).where(categories: { id: category.id }) }
end
