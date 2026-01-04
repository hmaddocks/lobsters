# typed: false

class HatRequestsController < ApplicationController
  before_action :require_logged_in_user
  before_action :show_title_h1

  def index
    @title = "Hat Requests"
    @hat_requests = @user.hat_requests
  end

  def new
    @title = "Request a Hat"
    @hat_request = HatRequest.new
  end

  def create
    @hat_request = HatRequest.new
    @hat_request.user_id = @user.id
    @hat_request.hat = params[:hat_request][:hat]
    @hat_request.link = params[:hat_request][:link]
    @hat_request.comment = params[:hat_request][:comment]

    if @hat_request.save
      flash[:success] = "Successfully submitted hat request."
      return redirect_to "/hats"
    end

    render action: :new
  end
end
