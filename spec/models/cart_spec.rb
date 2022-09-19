# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'with associations' do
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
    it { is_expected.to have_many(:items).through(:line_items) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:restaurant).optional(true) }
  end
end
