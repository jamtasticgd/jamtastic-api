module Contractable
  extend ActiveSupport::Concern

  included do
    attr_reader :contract_result

    @@contract_classes = {}

    def self.contracts(options)
      @@contract_classes[name] = options.with_indifferent_access
    end

    def contract_class
      class_contracts = @@contract_classes[self.class.name] || {}

      return nil if class_contracts.empty?

      class_contracts[params[:action]]
    end

    def validate_contract
      @contract_result = params.permit!.to_h

      return if contract_class.blank?

      @contract_result = contract_class.new.call(contract_result)

      raise InvalidContractError unless contract_result.success?
    end
  end
end
