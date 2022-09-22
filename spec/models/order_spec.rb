# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'with enums' do
    it { is_expected.to define_enum_for(:status).with_values({ ordered: 0, paid: 1, cancelled: 2, completed: 3 }) }
  end

  describe 'with associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
  end

  describe 'with callbacks' do
    subject(:order) do
      FactoryBot.rewind_sequences
      cart = create(:cart_with_line_items)
      create(:order, user: cart.user, restaurant: cart.restaurant, line_items: cart.line_items)
    end

    describe '#update_total_price' do
      it 'is expected to update total price of the order after create commit' do
        expect(order.total_price).to eq(8260)
      end
    end
  end

  describe 'with scopes' do
    let(:order) { create(:order) }

    describe '.of' do
      it 'is expected to give orders of given user' do
        expect(described_class.of(order.user)).to eq([order])
      end
    end

    describe '.with' do
      it 'is expected to give orders with given status' do
        expect(described_class.with(order.status)).to eq([order])
      end
    end
  end
end
