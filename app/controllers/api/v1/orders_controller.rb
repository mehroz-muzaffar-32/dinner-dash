# frozen_string_literal: true

module Api
  module V1
    class OrdersController < ApplicationController
      def index
        @orders = Order.all
      end
    end
  end
end
