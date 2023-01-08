class Data::LinkRowJob
  include Sidekiq::Job

  def perform(row_id)
    matches = linkables(row_id)
    return unless matches.present?

    repository.with_aggregate(Data::Row.new(row_id), stream(row_id)) do |d_row|
      matches.each do |match|
        d_match = repository.load(Data::Row.new(match.id), stream(match.id))
        d_row.link(d_match)
      end
    end
  end

  def stream(row_id)
    "Data::Row$#{row_id}"
  end

  def read_model
    @read_model ||= RowReadModel.new
  end

  def linkables(row_id)
    read_model.linkable_rows(row_id)
  end

  def repository
    AggregateRoot::Repository.new
  end
end
