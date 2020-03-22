# frozen_string_literal: true

require 'rails_helper'

describe 'tickets', type: :request do
  let(:ticket) { create(:ticket) }

  before(:each) do
    post '/api/tickets', params: { barcode: ticket.barcode, ticketedtime: ticket.ticketedtime }
  end

  context '#Post' do
    it 'posts a ticket' do
      expect(response).to have_http_status(:created)
    end

    it 'gets a ticket' do
      get '/api/tickets'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(2)
    end
  end
end
