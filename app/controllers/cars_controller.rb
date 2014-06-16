class CarsController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def not_found
    respond_to do |format|
      format.json { render :text => '{"error": "not_found"}', :status => 404 }
    end
  end
  def index
    @cars = Car.all
  end

  def show
    @car = Car.find(params[:id])
  end
end
