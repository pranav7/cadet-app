class ErrorsController < ApplicationController
  layout "public"

  def show
    @status_code = params[:code] || 500

    case @status_code.to_i
    when 404
      @error_title = "Uh oh. That page doesn’t exist. It’s confusing, we know."
    else
      @error_title = "We're sorry, but something went wrong."
    end

    render status: @status_code
  end
end
