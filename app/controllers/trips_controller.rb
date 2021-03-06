class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :update, :destroy]

  def index
    @trips = Trip.all
    render json: @trips
  end

  def show
    render json: @trip
  end

  # def create
  #   @trip = Trip.new(trip_params)
  #   if @trip.save
  #     @user_trip = UserTrip.new(user_trip_params)
  #     @user_trip.user_id = user_in_session.id
  #     @user_trip.trip_id = @trip.id
  #     @user_trip.save
  #     @destinations = params[:destinations].each { |d| Destination.find_or_create_by(lat: d['lat'], lng: d['lng'])}
  #     render json: {trip: TripSerializer.new(@trip), user_trip: UserTripSerializer.new(@user_trip), destinations: @destinations}
  #   else
  #     render json: {errors: @trip.errors.full_messages}, status: 422
  #   end
  # end

  # def update
  #   if @trip.update(trip_params)
  #     render json: @trip
  #   else
  #     render json: {error: @trip.errors.full_messages}, status: 422
  #   end
  # end

  def destroy
    @trip.destroy
    render json: {message: "Trip deleted"}
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :description, :duration)
  end

  def user_trip_params
    params.require(:user_trip).permit(:ratings, :start_date, :end_date)
  end

  def destination_params
    params.require(:destinations).permit(:name, :description, :lat, :lng)
  end

  def set_trip
    @trip = Trip.find_by(id: params[:id])
  end

end
