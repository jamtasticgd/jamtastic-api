require 'rails_helper'

RSpec.describe Contracts::ErrorsSerializer do
  describe '#as_json' do
    context 'when the contract is valid' do
      it 'returns an empty array' do
        params = { name: 'Some company' }
        contract = Companies::CreateContract.new.call(params)

        result_json = described_class.new(contract).as_json

        expect(result_json).to eq({ errors: [] })
      end
    end

    context 'when the contract is invalid' do
      it 'returns an array containing the contract errors' do
        params = { name: '' }
        contract = Companies::CreateContract.new.call(params)

        result_json = described_class.new(contract).as_json

        expect(result_json).to eq(
          {
            errors: [{
              field: 'name',
              detail: 'não foi informado(a)'
            }]
          }
        )
      end
    end
  end
end
