# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineItemsController, type: :controller do
  let!(:cart) do
    FactoryBot.rewind_sequences
    create(:cart_with_a_line_item)
  end

  let(:user) { cart.user }

  before do
    sign_in user
  end

  describe LineItemPolicy do
    subject { described_class.new(user, cart.line_items.first) }

    describe '#admin?' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to forbid_actions(%i[create update destroy]) }
    end

    describe '#purchaser?' do
      it { is_expected.to permit_actions(%i[create update destroy]) }
    end
  end

  describe 'POST #create' do
    let!(:add_to_cart) { ->(item) { post :create, xhr: true, params: { item_id: item.id } } }

    context 'with valid parameters' do
      let!(:cartable_item) { create(:item, restaurant: cart.restaurant) }

      before { add_to_cart.call(cartable_item) }

      it 'adds item to cart' do
        expect(assigns(:current_cart).items).to include(cartable_item)
      end

      it { expect(flash[:notice]).to eq('Item added to cart') }
    end

    context 'with invalid parameters' do
      it 'shows flash error message' do
        uncartable_item = create(:item, :restaurant, :retired)
        add_to_cart.call(uncartable_item)
        expect(flash[:alert]).to eq('Item not added to cart')
      end

      it 'does not add item of other restaurant to cart' do
        item_of_other_restaurant = create(:item, :restaurant)
        add_to_cart.call(item_of_other_restaurant)
        expect(assigns(:current_cart).items).not_to include(item_of_other_restaurant)
      end

      it 'does not add already carted item to cart' do
        already_present_item = cart.items.first
        expect { add_to_cart.call(already_present_item) }.to change(LineItem, :count).by(0)
      end

      it 'does not add retired item to cart' do
        retired_item = create(:item, :retired, restaurant: cart.restaurant)
        add_to_cart.call(retired_item)
        expect(assigns(:current_cart).items).not_to include(retired_item)
      end

      it 'does not add item to cart without given id' do
        expect { post :create, xhr: true }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'when current user is Admin' do
      let(:user) { create(:user, :admin) }
      let!(:cartable_item) { create(:item, restaurant: cart.restaurant) }

      before { add_to_cart.call(cartable_item) }

      it('does not add item to cart') { expect(cart.items.reload).not_to include(cartable_item) }
      it { expect(response).to redirect_to(:root) }
    end
  end

  describe 'PATCH #update' do
    let!(:update_line_item) do
      lambda do |line_item, new_quantity|
        patch :update, xhr: true, params: { id: line_item.id, quantity_ordered: new_quantity }
      end
    end
    let(:line_item) { cart.line_items.first }

    context 'with valid parameters' do
      let!(:new_valid_quantity) { 5 }

      before { update_line_item.call(line_item, new_valid_quantity) }

      it('assigns @line_item ith given value') { expect(assigns(:line_item)).to eq(line_item) }
      it('updates quantity of line_item') { expect(line_item.reload.quantity_ordered).to eq(new_valid_quantity) }
    end

    context 'with invalid parameters' do
      let!(:new_invalid_quantity) { 0 }

      before { update_line_item.call(line_item, new_invalid_quantity) }

      it 'does not update quantity to invalid value' do
        expect(line_item.reload.quantity_ordered).not_to eq(new_invalid_quantity)
      end

      it 'does not update quantity when id not given' do
        expect { patch :update, xhr: true }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'when current user is Admin' do
      let(:user) { create(:user, :admin) }
      let!(:new_valid_quantity) { 5 }

      before { update_line_item.call(line_item, new_valid_quantity) }

      it('does not update line item') { expect(line_item.reload.quantity_ordered).not_to eq(new_valid_quantity) }
      it { expect(flash[:alert].message).to eq('not allowed to update? this LineItem') }
      it { expect(response).to redirect_to(:root) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:destroy_line_item) { ->(line_item) { delete :destroy, xhr: true, params: { id: line_item.id } } }
    let!(:line_item) { cart.line_items.first }

    context 'when current user is Purchaser' do
      before { destroy_line_item.call(line_item) }

      it('assigns @line_item with given value') { expect(assigns(:line_item)).to eq(line_item) }
      it('destroys the line_item with given id') { expect(assigns(:current_cart).line_items).not_to include(line_item) }

      it 'does not destroy line_item when id not given' do
        expect { delete :destroy, xhr: true }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'when current user is Admin' do
      let(:user) { create(:user, :admin) }

      before { destroy_line_item.call(line_item) }

      it('does not destroy line item with given id') do
        expect { response }.to change(LineItem, :count).by(0)
      end

      it { expect(flash[:alert].message).to eq('not allowed to destroy? this LineItem') }
      it { expect(response).to redirect_to(:root) }
    end
  end
end
