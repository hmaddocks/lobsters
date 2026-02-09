# typed: false

class Mod::HatRequestsController < Mod::ModController
  before_action :require_logged_in_moderator
  before_action :show_title_h1

  def index
    @title = "Hat Requests"
    @hat_requests = HatRequest.all.includes(:user)
  end

  def approve
    @hat_request = HatRequest.find(params[:id])
    @hat_request.update!(params.require(:hat_request)
      .permit(:hat, :link, :reason).except(:reason))
    @hat_request.approve_by_user_for_reason!(@user, params[:hat_request][:reason])

    flash[:success] = "Successfully approved hat request."

    redirect_to hat_requests_path

  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to approve hat request: #{e.message}"
    render :index
  end

  def reject
    @hat_request = HatRequest.find(params[:id])
    @hat_request.reject_by_user_for_reason!(@user, params[:hat_request][:reason])

    flash[:success] = "Successfully rejected hat request."

    redirect_to hat_requests_path

  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to reject hat request: #{e.message}"
    render :index
  end
end
