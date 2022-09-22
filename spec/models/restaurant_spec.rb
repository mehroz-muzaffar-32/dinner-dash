# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'with associations' do
    it { is_expected.to have_many(:items).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end
end
