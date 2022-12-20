class RowsController < ApplicationController
  def index
    @rows = search_params? ? search : Row.all
  end

  def edit
    @row = Row.find(params[:id])
  end

  def show
    @row = Row.find(params[:id])
    @duplicate_rows = Row.with_hash(@row.data_hash).where.not(id: @row.id)
    stream = "Data::Row$#{@row.id}"
    @events = Rails.configuration.event_store.read.stream(stream).to_a
  end

  def update
    params.permit!
    updated_by = SecureRandom.uuid
    row_id = params[:id]
    row_number = params[:row_number]
    data = params[:data]
    command = Data::Commands::UpdateRow.new(row_id, data, updated_by)
    command_bus.call(command)
  end

  private

  def search
    scope = Row.where(nil)
    scope = scope.with_hash(hash_param) if hash_param?
    scope = scope.with_state(state_param) if state_param?
    scope = scope.with_id(id_param) if id_param?
    scope = scope.with_data(data_params) if data_params?
    scope
  end

  def search_params
    @search_params ||=
     begin
       params[:query]&.split&.reduce({}) do |p, search_k_v|
         k_and_v = search_k_v.split(':')
         p[k_and_v.first] = k_and_v.second
         p
       end
     end
  end

  def search_params?
    search_params.present? && !search_params.empty?
  end

  def param(name)
    return unless search_params?

    search_params[name]
  end

  def param?(name)
    !param(name).nil?
  end

  def data_params?
    !data_params.nil? && !data_params.empty?
  end

  def data_params
    return unless search_params?

    search_params.except('id', 'hash', 'state')
  end

  def state_param
    param('state')
  end

  def state_param?
    param?('state')
  end

  def hash_param
    param('hash')
  end

  def hash_param?
    param?('hash')
  end

  def id_param
    param('id')
  end

  def id_param?
    param?('id')
  end
end
