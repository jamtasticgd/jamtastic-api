require 'rails_helper'

RSpec.describe Models::ErrorsSerializer do
  describe '#as_json' do
    context 'when the model is valid' do
      it 'returns an empty array' do
        company = Company.create(name: 'Some company')

        result_json = described_class.new(company).as_json

        expect(result_json).to eq({ errors: [] })
      end
    end

    context 'when the model is invalid' do
      it 'returns an array containing the contract errors' do
        company = Company.create

        result_json = described_class.new(company).as_json

        expect(result_json).to eq(
          {
            errors: [{
              field: 'name',
              detail: 'não pode ficar em branco'
            }]
          }
        )
      end
    end
  end
end
