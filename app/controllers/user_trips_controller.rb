class UserTripsController < ApplicationController
  before_action :set_user_trip, only: [:show, :update, :destroy]

  def index
    @user_trips = UserTrip.where(user_id: user_in_session.id)
    render json: @user_trips
  end

  def show
    render json: @user_trip
  end

  def create
    @user_trip = UserTrip.new(user_trip_params)
    trip = Trip.find_or_create_by(trip_params)
    @user_trip.trip_id = trip.id
    @user_trip.user_id = user_in_session.id
    params[:destinations].map do |d|
      destination = Destination.find_or_create_by(name: d['name'], description: d['description'], lat: d['lat'], lng: d['lng'])
      TripDestination.create(trip_id: trip.id, destination_id: destination.id, arrival: d['arrival'], departure: d['departure'])
    end
    if @user_trip.save
      @user_trip.travel_age = @user_trip.start_date.year - user_in_session.dob.year
      render json: @user_trip
    else
      render json: {errors: @user_trip.errors.full_messages}, status: 422
    end
  end

  def update
    trip = Trip.find_by(id: @user_trip.trip_id)
    trip.update(trip_params)
    trip.destinations.clear
    params[:destinations].map { |d|
      new_destination = Destination.find_or_create_by(name: d['name'], description: d['description'], lat: d['lat'], lng: d['lng'])
      puts 'ARRIVAL TIME:' + d['arrival']
      TripDestination.create(trip_id: trip.id, destination_id: new_destination.id, arrival: d['arrival'], departure: d['departure'])
    }
    if @user_trip.update(user_trip_params)
      render json: @user_trip
    else
      render json: {error: @user_trip.errors.messages}
    end
  end

  def destroy
    @user_trip.destroy
    render json: {message: "Trip is deleted from your collection."}
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :description, :duration)
  end

  def user_trip_params
    params.require(:user_trip).permit(:ratings, :start_date, :end_date)
  end

  def set_user_trip
    @user_trip = UserTrip.find_by(id: params[:id])
  end

end
