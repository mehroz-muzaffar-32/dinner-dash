# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'with validations' do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_length_of(:display_name).is_at_least(2) }
    it { is_expected.to validate_length_of(:display_name).is_at_most(32) }
  end

  describe 'with enums' do
    it { is_expected.to define_enum_for(:role).with_values({ purchaser: 0, admin: 1 }) }
  end

  describe 'with associations' do
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_one(:cart).dependent(:destroy) }
  end
end
