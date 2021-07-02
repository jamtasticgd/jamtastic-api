module Contracts
  class ErrorsSerializer
    def self.render(contract)
      new(contract)
    end

    def initialize(contract)
      @contract = contract
    end

    def as_json(_options = nil)
      { errors: errors }
    end

    private

    def errors
      grouped_errors = @contract.errors.messages.group_by(&:path)

      grouped_errors.map do |path, messages|
        {
          field: path.join('/'),
          detail: messages.map(&:text).to_sentence
        }
      end
    end
  end
end
