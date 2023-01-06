class FileFormatsController < ApplicationController
  def index
    @formats = FileFormat.all
  end

  def show
    @format = FileFormat.find(params[:id])
  end
end
