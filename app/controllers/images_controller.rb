class ImagesController < ApplicationController
  before_action :authenticate_user!

  def create
    uploaded_image = Image.new
    uploaded_image.image = params[:file]
    if uploaded_image.save
      render json: { url: uploaded_image.image.url }
    else
      render status: 400
    end
  end
end
