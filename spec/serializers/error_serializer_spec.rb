require 'rails_helper'

RSpec.describe ErrorSerializer do
  describe '#as_json' do
    it 'returns an array containing the message' do
      result_json = described_class.new('Error message').as_json

      expect(result_json).to eq({ errors: ['Error message'] })
    end
  end
end
