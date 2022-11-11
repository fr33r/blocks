# frozen_string_literal: true

module Domain
  module Events
    # ====== ROW ====== #

    # Domain event that occurs when the row is uploaded.
    class RowUploaded < RailsEventStore::Event; end
    # Domain event that occurs when the row data is updated.
    class RowUpdated < RailsEventStore::Event; end
    # Domain event that occurs when the row is filtered.
    class RowFiltered < RailsEventStore::Event; end
    # Domain event that occurs when the row is validated.
    class RowValidated < RailsEventStore::Event; end
    # Domain event that occurs when the row is invalidated.
    class RowInvalidated < RailsEventStore::Event; end
    # Domain event that occurs when the row is ingested.
    class RowIngested < RailsEventStore::Event; end

    # ====== File ====== #

    # Domain event that occurs when the file is uploaded.
    class FileUploaded < RailsEventStore::Event; end
    # Domain event that occurs when the file is processing.
    class FileProcessing < RailsEventStore::Event; end
    # Domain event that occurs when the file is completely processed.
    class FileProcessed < RailsEventStore::Event; end

    # ====== Rule ====== #

    # Domain event that occurs when the rule is created.
    class RuleCreated < RailsEventStore::Event; end
    # Domain event that occurs when the rule is activated.
    class RuleActivated < RailsEventStore::Event; end
    # Domain event that occurs when the rule is inactivated.
    class RuleInactivated < RailsEventStore::Event; end

    # ====== File FORMAT ====== #

    # Domain event that occurs when the file format is created.
    class FileFormatCreated < RailsEventStore::Event; end
    # Domain event that occurs when the file format is activated.
    class FileFormatActivated < RailsEventStore::Event; end
    # Domain event that occurs when the file format is inactivated.
    class FileFormatInactivated < RailsEventStore::Event; end

    # ====== PIPELINE ====== #

    # Domain event that occurs when the pipeline is created.
    class PipelineCreated < RailsEventStore::Event; end
    # Domain event that occurs when the pipeline is activated.
    class PipelineActivated < RailsEventStore::Event; end
    # Domain event that occurs when the pipeline is inactivated.
    class PipelineInactivated < RailsEventStore::Event; end
  end
end
