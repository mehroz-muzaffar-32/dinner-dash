# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'with associations' do
    it { is_expected.to have_many(:categories_items).dependent(:destroy) }
    it { is_expected.to have_many(:items).through(:categories_items) }
  end
end
