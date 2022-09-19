# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe 'with validations' do
    it { is_expected.to validate_presence_of(:quantity_ordered) }
    it { is_expected.to validate_numericality_of(:quantity_ordered).is_greater_than(0) }
  end

  describe 'with associations' do
    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:container) }
  end
end
