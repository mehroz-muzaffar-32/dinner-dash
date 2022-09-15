# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :full_name, presence: true
  validates :display_name, length: { in: 2..32 }, allow_blank: true

  enum role: { purchaser: 0, admin: 1 }

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
end
