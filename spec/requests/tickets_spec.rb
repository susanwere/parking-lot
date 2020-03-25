# frozen_string_literal: true

require 'rails_helper'

describe 'tickets', type: :request do

  before(:each) do
    post '/api/tickets'
  end

  it 'posts a ticket' do
    expect(response).to have_http_status(:created)
  end

  it 'gets a ticket' do
    get '/api/tickets'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).count).to eq(1)
  end

  it 'gets a ticket by barcode' do
    get '/api/tickets'
    barcode = JSON.parse(response.body)[0]['barcode']
    get api_get_by_barcode_url(barcode)
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['barcode']).to eq(barcode)
  end

  it 'doesnt get a non-existing ticket' do
    get api_get_by_barcode_url("fbarcode")
    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq("ActiveRecord::RecordNotFound")
  end

  it 'doesnt posts payment for a ticket without params' do
    get '/api/tickets'
    barcode = JSON.parse(response.body)[0]['barcode']
    post api_payment_url(barcode)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['message']).to eq("param is missing or the value is empty: ticket")
  end

  it 'checks the state of a ticket' do
    get '/api/tickets'
    barcode = JSON.parse(response.body)[0]['barcode']
    get api_check_payment_state_url(barcode)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['unpaid']).to eq("You need to make a payment")
  end
end
