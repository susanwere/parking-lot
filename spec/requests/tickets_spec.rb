# frozen_string_literal: true

require 'rails_helper'

describe 'tickets', type: :request do
  let(:ticket) { create(:ticket) }
  let(:paid_ticket) { create(:ticket, paid: true) }

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


    it 'gets a ticket by barcode' do
      get api_get_by_barcode_url(ticket.barcode)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['barcode']).to eq(ticket.barcode)
    end

    it 'doesnt get a non-existing ticket' do
      get api_get_by_barcode_url("barcode")
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['message']).to eq("ActiveRecord::RecordNotFound")
    end

    it 'posts payment for a ticket' do
      post api_payment_url(ticket.barcode), params: { payment_option: "credit_card", price_cents: 4 }, as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['barcode']).to eq(ticket.barcode)
    end

    it 'doesnt posts payment for a ticket without params' do
      post api_payment_url(ticket.barcode), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['message']).to eq("param is missing or the value is empty: ticket")
    end

    it 'doesnt posts payment for a ticket if it has already been paid' do
      post api_payment_url(paid_ticket.barcode), params: { payment_option: "credit_card", price_cents: 4, paid: true }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq("This ticket has already been paid for")
    end
  end
end
