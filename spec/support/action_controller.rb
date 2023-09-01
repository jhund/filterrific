# Simulate ActionController::Parameters so that we can test the behavior of
# the gem with Rails.
module ActionController
  class Parameters
    def initialize(hash = {})
      self.unsafe_hash = hash
    end

    def [](key)
      unsafe_hash[key]
    end

    def []=(key, value)
      unsafe_hash[key] = value
    end

    def each(&block)
      unsafe_hash.each(&block)
    end

    def to_unsafe_h
      unsafe_hash
    end

    def permit(*)
      self
    end

    private

    attr_accessor :unsafe_hash
  end
end
