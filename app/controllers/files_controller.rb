class FilesController < ApplicationController
  def index
    @files = DataFile.all
  end

  def show
    @file = DataFile.find(params[:id])
    stream = "Data::File$#{@file.id}"
    @events = Rails.configuration.event_store.read.stream(stream).to_a
  end
end
