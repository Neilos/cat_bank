# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts' do
  describe 'GET /accounts/id' do
    let(:account) { create(:account) }

    it 'returns http success' do
      get "/accounts/#{account.id}"

      expect(response).to have_http_status(:success)
    end
  end
end
