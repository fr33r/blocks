# frozen_string_literal: true

module Data
  class Anchor
    attr_reader :id
    attr_reader :name
    attr_reader :description
    attr_reader :column_ids

    def initialize(id, name, description, column_ids)
      @id = id
      @name = name
      @description = description
      @column_ids = column_ids
    end

    def to_hash
      {
        id: id,
        name: name,
        description: description,
        column_ids: column_ids,
      }
    end

    alias :to_h :to_hash
  end
end
