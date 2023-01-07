class FilesController < ApplicationController
  def index
    @files = DataFile.all
  end

  def show
    @file = DataFile.find(params[:id])
  end
end
