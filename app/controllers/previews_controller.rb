class PreviewsController < ApplicationController
  def create
    @body = params.require(:body)
    render layout: false
  end
end
