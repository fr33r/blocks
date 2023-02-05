# frozen_string_literal: true

module Hashers
  class Md5
    def self.hash(source)
      Digest::MD5.hexdigest(source)
    end
  end
end
