# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :admin) }
  let!(:restaurant) { FactoryBot.create(:restaurant) }

  before do
    sign_in user
  end

  describe RestaurantPolicy do
    subject { described_class.new(user, restaurant) }

    describe '#admin?' do
      it { is_expected.to permit_actions(%i[index show create new update edit destroy]) }
    end

    describe '#purchaser?' do
      let(:user) { FactoryBot.create(:user) }

      it { is_expected.to permit_actions(%i[index show]) }
      it { is_expected.to forbid_actions(%i[create new update edit destroy]) }
    end
  end

  describe 'GET /index' do
    before { get :index }

    it { expect(assigns(:restaurants)).to be_a_all(Restaurant) }
  end

  describe 'GET /show[:id]' do
    it 'shows restaurant with given id' do
      get :show, params: { id: restaurant.id }
      expect(response).to render_template(:show)
    end

    it 'does not show restaurant when id not given' do
      expect { get :show }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'GET /new' do
    context 'with Admin' do
      before { get :new }

      it { expect(assigns(:restaurant)).to be_a_new(Restaurant) }
    end

    context 'with Purchaser' do
      let(:user) { FactoryBot.create(:user) }

      before { get :new }

      it { expect(response).to redirect_to(:root) }
      it { expect(flash[:alert].message).to eq('not allowed to new? this Restaurant') }
    end
  end

  describe 'POST /create' do
    let!(:sender) { ->(restaurant_params) { post :create, params: { restaurant: restaurant_params } } }

    context 'with valid parameters' do
      it { expect { sender.call(attributes_for(:restaurant)) }.to change(Restaurant, :count).by(1) }
    end

    context 'with invalid parameters' do
      it 'does not create restaurant with blank name' do
        expect { sender.call(attributes_for(:restaurant, :blank_name)) }.to change(Restaurant, :count).by(0)
      end

      it 'does not create restaurant with same name' do
        expect { sender.call(attributes_for(:restaurant, name: restaurant.name)) }.to change(Restaurant, :count).by(0)
      end
    end

    context 'with Purchaser' do
      let(:user) { FactoryBot.create(:user) }

      before { sender.call(attributes_for(:restaurant)) }

      it { expect { response }.to change(Restaurant, :count).by(0) }
      it { expect(flash[:alert].message).to eq('not allowed to create? this Restaurant') }
      it { expect(response).to redirect_to(:root) }
    end
  end

  describe 'GET /edit[:id]' do
    context 'with Admin' do
      before { get :edit, params: { id: restaurant.id } }

      it { expect(assigns(:restaurant)).to be_a(Restaurant) }
      it { expect(response).to be_successful }
      it { expect { get :edit }.to raise_error(ActionController::UrlGenerationError) }
    end

    context 'with Purchaser' do
      let(:user) { FactoryBot.create(:user) }

      before { get :edit, params: { id: restaurant.id } }

      it { expect(response).to redirect_to(:root) }
      it { expect(flash[:alert].message).to eq('not allowed to edit? this Restaurant') }
    end
  end

  describe 'PUT /update[:id]' do
    before { put :update, params: { id: restaurant.id, restaurant: attributes_for(:restaurant) } }

    let!(:sender) do
      ->(restaurant_params) { put :update, params: { id: restaurant.id, restaurant: restaurant_params } }
    end

    context 'with valid parameters' do
      it { expect(response).to redirect_to(restaurant) }
    end

    context 'with invalid parameters' do
      let!(:other_restaurant) { create(:restaurant) }

      it 'does not update restaurant name to blank' do
        sender.call(attributes_for(:restaurant, :blank_name))
        expect(response).to render_template(:edit)
      end

      it 'does not update restaurant name to already taken name' do
        sender.call(attributes_for(:restaurant, name: other_restaurant.name))
        expect(response).to render_template(:edit)
      end

      it 'does not update restaurant when id not given' do
        expect { put :update }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'with Purchaser' do
      let(:user) { FactoryBot.create(:user) }

      before { sender.call(attributes_for(:restaurant)) }

      it { expect(flash[:alert].message).to eq('not allowed to update? this Restaurant') }
      it { expect(response).to redirect_to(:root) }
    end
  end

  describe 'DELETE /destroy[:id]' do
    let!(:sender) { -> { delete :destroy, params: { id: restaurant.id } } }

    context 'with Admin' do
      it 'must destroy the restaurant with given id' do
        expect { sender.call }.to change(Restaurant, :count).by(-1)
      end

      it 'must not destroy the restaurant when id not given' do
        expect { delete :destroy }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'with Purchaser' do
      let(:user) { FactoryBot.create(:user) }

      before { sender.call }

      it 'must not destroy the restaurant with given id' do
        expect { response }.to change(Restaurant, :count).by(0)
      end

      it { expect(flash[:alert].message).to eq('not allowed to destroy? this Restaurant') }
      it { expect(response).to redirect_to(:root) }
    end
  end
end
