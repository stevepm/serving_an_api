class CarsController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  before_action :restrict_access, only: [:create]

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

  def create
    json = params["car"]
    @car = Car.create(:color => json["color"],
                      :doors => json["doors"],
                      :purchased_on => json["purchased_on"],
                      :make => json["make"]["id"])
    respond_to do |format|
      format.json { render :action => 'show', :status => 200, :location => @car }
    end
  end

  private

  def restrict_access
    # authenticate_or_request_with_http_token do |token, options|
    #   ApiKey.exists?(access_token: token)
    # end
    unless ApiKey.exists?(access_token: request.headers["Authorization"])
      respond_to do |format|
        format.json { render :text => '{"error": "not_found"}', :status => 401 }
      end
    end
  end

end
