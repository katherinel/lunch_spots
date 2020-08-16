class SpotsController < ApplicationController
  before_action :authorized

  def search
    render json: Spot.search_by_location(spot_params[:location], spot_params[:keyword])
  end

  private

  def spot_params
    params.permit(:location, :keyword)
  end
end
