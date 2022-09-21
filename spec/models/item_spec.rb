# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'with validations' do
    subject { create(:item, :restaurant) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:categories) }
  end

  describe 'with enums' do
    it { is_expected.to define_enum_for(:status).with_values({ not_retired: 0, retired: 1 }) }
  end

  describe 'with associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_many(:line_items).dependent(:nullify) }
    it { is_expected.to have_many(:categories_items).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:categories_items) }
    it { is_expected.to have_one_attached(:photo) }
  end
end
