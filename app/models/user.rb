# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { purchaser: 0, admin: 1 }

  after_initialize :set_empty_display_name_to_null, if: :new_record?

  def set_empty_display_name_to_null
    return unless display_name&.strip&.empty?

    self.display_name = nil
  end
end
