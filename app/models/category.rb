# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :categories_items, dependent: :destroy
  has_many :items, through: :categories_items

  validates :name, presence: true
  validates :name, uniqueness: true
end
