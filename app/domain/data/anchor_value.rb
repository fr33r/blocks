# frozen_string_literal: true

module Data
  class AnchorValue
    attr_reader :data
    attr_reader :anchor_id

    def initialize(data, anchor_id, hasher = ::Hashers::Md5)
      @data = data
      @anchor_id = anchor_id
      @hasher = hasher
    end

    def to_hash
      {
        data: data,
        hash: hash,
        anchor_id: anchor_id,
      }
    end

    alias :to_h :to_hash

    private

    attr_reader :hasher

    def hash
      @hash ||= hasher.hash(normalized_data_values.to_yaml)
    end

    def normalized_data_values
      data.values.map(&:to_s).sort.map(&:downcase)
    end
  end
end
