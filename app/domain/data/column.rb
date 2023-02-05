# frozen_string_literal: true

module Data
  class Column
    class DataType
      INTEGER = :integer
      STRING = :string
      DATE = :date
      DATETIME = :datetime
      DECIMAL = :decimal
    end

    attr_reader :id
    attr_reader :name
    attr_reader :description
    attr_reader :required
    attr_reader :data_type

    def initialize(id, name, description, required, data_type)
      @id = id
      @name = name
      @description = description
      @required = required
      @data_type = data_type
    end

    def to_hash
      {
        id: id,
        name: name,
        description: description,
        required: required,
        data_type: data_type,
      }
    end

    alias :required? :required
    alias :to_h :to_hash
  end
end
