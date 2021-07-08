module Models
  class ErrorsSerializer
    def self.render(model)
      new(model)
    end

    def initialize(model)
      @model = model
    end

    def as_json(_options = nil)
      { errors: errors }
    end

    private

    def errors
      @model.errors.messages.map do |field, messages|
        {
          field: field.to_s,
          detail: messages.join
        }
      end
    end
  end
end
