# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  let(:user) { create(:user, :admin) }
  let!(:restaurant) { create(:restaurant) }

  before do
    sign_in user
  end

  describe RestaurantPolicy do
    subject { described_class.new(user, restaurant) }

    describe '#admin?' do
      it { is_expected.to permit_actions(%i[index show create new update edit destroy]) }
    end

    describe '#purchaser?' do
      let(:user) { create(:user) }

      it { is_expected.to permit_actions(%i[index show]) }
      it { is_expected.to forbid_actions(%i[create new update edit destroy]) }
    end
  end

  describe 'GET #index' do
    before { get :index }

    it { expect(assigns(:restaurants)).to be_a_all(Restaurant) }
  end

  describe 'GET #show' do
    it 'assigns @restaurant with given value' do
      get :show, params: { id: restaurant.id }
      expect(assigns(:restaurant)).to eq(restaurant)
    end

    it 'does not show restaurant when id not given' do
      expect { get :show }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'GET #new' do
    context 'when current user is Admin' do
      before { get :new }

      it { expect(assigns(:restaurant)).to be_a_new(Restaurant) }
    end

    context 'when current user is Purchaser' do
      let(:user) { create(:user) }

      before { get :new }

      it { expect(response).to redirect_to(:root) }
      it { expect(flash[:alert].message).to eq('not allowed to new? this Restaurant') }
    end
  end

  describe 'POST #create' do
    let!(:create_restaurant) { ->(restaurant_params) { post :create, params: { restaurant: restaurant_params } } }

    context 'with valid parameters' do
      it { expect { create_restaurant.call(attributes_for(:restaurant)) }.to change(Restaurant, :count).by(1) }
    end

    context 'with invalid parameters' do
      it 'does not create restaurant with blank name' do
        expect { create_restaurant.call(attributes_for(:restaurant, :blank_name)) }.to change(Restaurant, :count).by(0)
      end

      it 'does not create restaurant with same name' do
        expect do
          create_restaurant.call(attributes_for(:restaurant, name: restaurant.name))
        end.to change(Restaurant, :count).by(0)
      end
    end

    context 'when current user is Purchaser' do
      let(:user) { create(:user) }

      before { create_restaurant.call(attributes_for(:restaurant)) }

      it { expect { response }.to change(Restaurant, :count).by(0) }
      it { expect(flash[:alert].message).to eq('not allowed to create? this Restaurant') }
      it { expect(response).to redirect_to(:root) }
    end
  end

  describe 'GET #edit' do
    context 'when current user is Admin' do
      before { get :edit, params: { id: restaurant.id } }

      it('assigns @restaurant with given value') { expect(assigns(:restaurant)).to eq(restaurant) }
      it { expect(response).to be_successful }

      it 'does not edit restaurant when id not given' do
        expect { get :edit }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'when current user is Purchaser' do
      let(:user) { create(:user) }

      before { get :edit, params: { id: restaurant.id } }

      it { expect(response).to redirect_to(:root) }
      it { expect(flash[:alert].message).to eq('not allowed to edit? this Restaurant') }
    end
  end

  describe 'PUT #update' do
    let!(:update_restaurant) do
      ->(restaurant_params) { put :update, params: { id: restaurant.id, restaurant: restaurant_params } }
    end

    context 'with valid parameters' do
      it 'updates restaurant' do
        with_valid_attributes = attributes_for(:restaurant)
        update_restaurant.call(with_valid_attributes)
        expect(restaurant.reload.name).to eq(with_valid_attributes[:name])
      end
    end

    context 'with invalid parameters' do
      let!(:other_restaurant) { create(:restaurant) }

      it 'does not update restaurant due to blank name' do
        with_blank_name = attributes_for(:restaurant, :blank_name)
        update_restaurant.call(with_blank_name)
        expect(restaurant.reload).to eq(restaurant)
      end

      it 'does not update restaurant due to already taken name' do
        with_same_name = attributes_for(:restaurant, name: other_restaurant.name)
        update_restaurant.call(with_same_name)
        expect(restaurant.reload).to eq(restaurant)
      end

      it 'does not update restaurant when id not given' do
        expect { put :update }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'when current user is Purchaser' do
      let(:user) { create(:user) }

      before { update_restaurant.call(attributes_for(:restaurant)) }

      it { expect(flash[:alert].message).to eq('not allowed to update? this Restaurant') }
      it { expect(response).to redirect_to(:root) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:destroy_restaurant) { -> { delete :destroy, params: { id: restaurant.id } } }

    context 'when current user is Admin' do
      it 'destroys the restaurant with given id' do
        expect { destroy_restaurant.call }.to change(Restaurant, :count).by(-1)
      end

      it 'does not destroy the restaurant when id not given' do
        expect { delete :destroy }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'when current user is Purchaser' do
      let(:user) { create(:user) }

      before { destroy_restaurant.call }

      it 'does not destroy the restaurant with given id' do
        expect { response }.to change(Restaurant, :count).by(0)
      end

      it { expect(flash[:alert].message).to eq('not allowed to destroy? this Restaurant') }
      it { expect(response).to redirect_to(:root) }
    end
  end
end
