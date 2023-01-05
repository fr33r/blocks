# frozen_string_literal: true

module Data
  module Commands
    class CreateFileFormat
      include ActiveModel::Validations

      attr_accessor :id
      attr_accessor :name
      attr_accessor :created_by
      attr_accessor :columns_args
      attr_accessor :anchors_args

      validates_presence_of :id
      validates_presence_of :name
      validates_presence_of :created_by
      # validates :anchor_columns_exist
      # validates :required_column_data_provided
      # validates :required_anchor_data_provided

      def initialize(id, name, columns_args, anchors_args, created_by)
        @id = id
        @name = name
        @columns_args = columns_args
        @anchors_args = anchors_args
        @created_by = created_by
      end

      private

      def required_column_data_provided
        # todo
      end

      def required_anchor_data_provided
        # todo
      end

      def anchor_columns_exist
        unique_anchor_column_names = anchor_args.map do |anchor_arg|
          anchor_arg.fetch(:columns)
        end.flatten.uniq

        unique_anchor_column_names.each do |anchor_column_name|
          matching_column = columns_args.find do |column_arg|
            column_arg.fetch(:name).downcase == anchor_column_name.downcase
          end

          if matching_column.nil?
            msg = "Anchor references column #{anchor_column_name} but that column doesn't exist"
            errors.add(:anchors, msg)
          end
        end
      end
    end
  end
end
