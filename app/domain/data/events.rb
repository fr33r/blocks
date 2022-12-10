# frozen_string_literal: true

module Data
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

    # ====== FILE ====== #

    # Domain event that occurs when the file is uploaded.
    class FileUploaded < RailsEventStore::Event; end
    # Domain event that occurs when the file is processing.
    class FileProcessing < RailsEventStore::Event; end
    # Domain event that occurs when the file is completely processed.
    class FileProcessed < RailsEventStore::Event; end

    # ====== FILE FORMAT ====== #

    # Domain event that occurs when the file format is created.
    class FileFormatCreated < RailsEventStore::Event; end
    # Domain event that occurs when the file format is activated.
    class FileFormatActivated < RailsEventStore::Event; end
    # Domain event that occurs when the file format is inactivated.
    class FileFormatInactivated < RailsEventStore::Event; end

    # ====== CONSTANTS ====== #
    ALL = [
      RowUploaded,
      RowUpdated,
      RowValidated,
      RowInvalidated,
      RowFiltered,
      RowIngested,
    ]
  end
end
