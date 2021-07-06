class ErrorSerializer
  def self.render(message)
    new(message)
  end

  def initialize(message)
    @message = message
  end

  def as_json(_options = nil)
    { errors: [@message] }
  end
end
