# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      before_action :set_item, only: :show

      def index
        @items = Item.all
      end

      def show; end

      private

      def set_item
        @item = Item.find(params[:id])
      end
    end
  end
end
