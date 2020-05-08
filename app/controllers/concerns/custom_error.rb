class CustomError < StandardError
  def initialize(exception = {})
    @errors = exception
    super
  end

  def to_h
    errors.deep_symbolize_keys
  end

  private

  attr_accessor :errors
end
