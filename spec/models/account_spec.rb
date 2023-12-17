# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  describe 'reference' do
    subject(:account_reference) { account.reference }

    let(:account) { described_class.create }

    it 'is automatically generated by the database' do
      expect(account_reference).not_to be_blank
    end
  end
end