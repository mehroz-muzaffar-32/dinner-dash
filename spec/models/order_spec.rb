# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'with enums' do
    it { is_expected.to define_enum_for(:status) }
  end

  describe 'with associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
  end
end
