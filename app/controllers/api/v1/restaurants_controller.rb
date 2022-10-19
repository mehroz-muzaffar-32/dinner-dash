# frozen_string_literal: true

module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        @restaurants = Restaurant.all
      end
    end
  end
end
